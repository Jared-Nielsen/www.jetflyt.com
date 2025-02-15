-- Create function to handle tender offer acceptance in a transaction
CREATE OR REPLACE FUNCTION accept_tender_offer(p_tender_id uuid, p_offer_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_tender_exists boolean;
  v_offer_exists boolean;
  v_result jsonb;
BEGIN
  -- Check if tender exists
  SELECT EXISTS (
    SELECT 1 FROM tenders WHERE id = p_tender_id
  ) INTO v_tender_exists;

  IF NOT v_tender_exists THEN
    RAISE EXCEPTION 'Tender with ID % not found', p_tender_id;
  END IF;

  -- Check if offer exists and belongs to the tender
  SELECT EXISTS (
    SELECT 1 FROM fbo_tenders 
    WHERE id = p_offer_id AND tender_id = p_tender_id
  ) INTO v_offer_exists;

  IF NOT v_offer_exists THEN
    RAISE EXCEPTION 'FBO tender with ID % not found or does not belong to tender %', p_offer_id, p_tender_id;
  END IF;

  -- Start transaction
  BEGIN
    -- Update tender status to accepted
    UPDATE tenders
    SET status = 'accepted',
        updated_at = NOW()
    WHERE id = p_tender_id;

    -- Update the accepted FBO tender
    UPDATE fbo_tenders
    SET status = 'accepted',
        updated_at = NOW()
    WHERE id = p_offer_id;

    -- Update all other FBO tenders to rejected
    UPDATE fbo_tenders
    SET status = 'rejected',
        updated_at = NOW()
    WHERE tender_id = p_tender_id
    AND id != p_offer_id;

    -- Prepare result
    v_result = jsonb_build_object(
      'success', true,
      'tender_id', p_tender_id,
      'offer_id', p_offer_id
    );

    -- Commit transaction
    RETURN v_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback transaction on any error
      ROLLBACK;
      RAISE;
  END;
END;
$$;
