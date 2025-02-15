-- Create a function to cancel an FBO tender
CREATE OR REPLACE FUNCTION cancel_fbo_tender(p_fbo_tender_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update the FBO tender status
  UPDATE fbo_tenders
  SET status = 'canceled'
  WHERE id = p_fbo_tender_id
  AND EXISTS (
    SELECT 1 FROM tenders
    WHERE tenders.id = fbo_tenders.tender_id
    AND tenders.auth_id = auth.uid()
  );
END;
$$;
