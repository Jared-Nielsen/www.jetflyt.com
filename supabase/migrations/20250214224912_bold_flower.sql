-- Drop existing function
DROP FUNCTION IF EXISTS accept_tender_offer;

-- Create stored procedure for accepting tender offers with proper status handling
CREATE OR REPLACE FUNCTION accept_tender_offer(
  p_tender_id uuid,
  p_offer_id uuid
) RETURNS void 
SECURITY DEFINER
AS $$
DECLARE
  v_auth_id uuid;
  v_tender_status text;
  v_offer_status text;
BEGIN
  -- Get current user's auth ID
  v_auth_id := auth.uid();
  
  -- Get tender status
  SELECT status INTO v_tender_status
  FROM tenders 
  WHERE id = p_tender_id 
  AND auth_id = v_auth_id;

  IF v_tender_status IS NULL THEN
    RAISE EXCEPTION 'Tender not found';
  END IF;

  IF v_tender_status != 'pending' THEN
    RAISE EXCEPTION 'Tender is already %', v_tender_status;
  END IF;

  -- Get FBO tender status
  SELECT status INTO v_offer_status
  FROM fbo_tenders 
  WHERE id = p_offer_id 
  AND tender_id = p_tender_id;

  IF v_offer_status IS NULL THEN
    RAISE EXCEPTION 'FBO tender not found';
  END IF;

  IF v_offer_status != 'pending' THEN
    RAISE EXCEPTION 'FBO tender is already %', v_offer_status;
  END IF;

  -- Update tender status
  UPDATE tenders 
  SET status = 'accepted'
  WHERE id = p_tender_id
  AND auth_id = v_auth_id
  AND status = 'pending';

  -- Verify tender update
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Failed to update tender status';
  END IF;

  -- Update the accepted FBO tender
  UPDATE fbo_tenders 
  SET status = 'accepted'
  WHERE id = p_offer_id
  AND tender_id = p_tender_id
  AND status = 'pending';

  -- Verify FBO tender update
  IF NOT FOUND THEN
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