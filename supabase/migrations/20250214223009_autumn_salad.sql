-- Drop existing function
DROP FUNCTION IF EXISTS accept_tender_offer;

-- Create stored procedure for accepting tender offers with proper permissions
CREATE OR REPLACE FUNCTION accept_tender_offer(
  p_tender_id uuid,
  p_offer_id uuid
) RETURNS void 
SECURITY DEFINER -- Run with definer's permissions
AS $$
DECLARE
  v_auth_id uuid;
  v_tender_exists boolean;
  v_offer_exists boolean;
BEGIN
  -- Get current user's auth ID
  v_auth_id := auth.uid();
  
  -- Check if tender exists and belongs to current user
  SELECT EXISTS (
    SELECT 1 
    FROM tenders 
    WHERE id = p_tender_id 
    AND auth_id = v_auth_id
    AND status = 'pending'
  ) INTO v_tender_exists;

  IF NOT v_tender_exists THEN
    RAISE EXCEPTION 'Tender not found or not in pending status';
  END IF;

  -- Check if FBO tender exists and belongs to the tender
  SELECT EXISTS (
    SELECT 1 
    FROM fbo_tenders 
    WHERE id = p_offer_id 
    AND tender_id = p_tender_id
    AND status = 'pending'
  ) INTO v_offer_exists;

  IF NOT v_offer_exists THEN
    RAISE EXCEPTION 'FBO tender not found or not in pending status';
  END IF;

  -- Update tender status
  UPDATE tenders 
  SET status = 'accepted'
  WHERE id = p_tender_id
  AND auth_id = v_auth_id;

  -- Verify tender update
  IF NOT EXISTS (
    SELECT 1 FROM tenders 
    WHERE id = p_tender_id 
    AND status = 'accepted'
  ) THEN
    RAISE EXCEPTION 'Failed to update tender status';
  END IF;

  -- Update the accepted FBO tender
  UPDATE fbo_tenders 
  SET status = 'accepted'
  WHERE id = p_offer_id
  AND tender_id = p_tender_id;

  -- Verify FBO tender update
  IF NOT EXISTS (
    SELECT 1 FROM fbo_tenders 
    WHERE id = p_offer_id 
    AND status = 'accepted'
  ) THEN
    RAISE EXCEPTION 'Failed to update FBO tender status';
  END IF;

  -- Update all other FBO tenders to rejected
  UPDATE fbo_tenders 
  SET status = 'rejected'
  WHERE tender_id = p_tender_id 
  AND id != p_offer_id
  AND status = 'pending';
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION accept_tender_offer(uuid, uuid) TO authenticated;