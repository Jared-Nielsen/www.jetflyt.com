-- Create stored procedure for accepting tender offers with transaction
CREATE OR REPLACE FUNCTION accept_tender_offer(
  p_tender_id uuid,
  p_offer_id uuid
) RETURNS void AS $$
BEGIN
  -- Start transaction
  BEGIN
    -- Update tender status first
    UPDATE tenders 
    SET status = 'accepted'
    WHERE id = p_tender_id;

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
    WHERE id = p_offer_id;

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
    AND id != p_offer_id;

    -- Commit transaction
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback on any error
      ROLLBACK;
      RAISE;
  END;
END;
$$ LANGUAGE plpgsql;