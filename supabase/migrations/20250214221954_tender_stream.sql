-- Create stored procedure for accepting tender offers
CREATE OR REPLACE FUNCTION accept_tender_offer(
  p_tender_id uuid,
  p_offer_id uuid
) RETURNS void AS $$
BEGIN
  -- Update tender status first
  UPDATE tenders 
  SET status = 'accepted'
  WHERE id = p_tender_id;

  -- Update the accepted FBO tender
  UPDATE fbo_tenders 
  SET status = 'accepted'
  WHERE id = p_offer_id;

  -- Update all other FBO tenders to rejected
  UPDATE fbo_tenders 
  SET status = 'rejected'
  WHERE tender_id = p_tender_id 
  AND id != p_offer_id;

  -- Verify the updates
  IF NOT EXISTS (
    SELECT 1 FROM tenders 
    WHERE id = p_tender_id 
    AND status = 'accepted'
  ) THEN
    RAISE EXCEPTION 'Failed to update tender status';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM fbo_tenders 
    WHERE id = p_offer_id 
    AND status = 'accepted'
  ) THEN
    RAISE EXCEPTION 'Failed to update FBO tender status';
  END IF;
END;
$$ LANGUAGE plpgsql;