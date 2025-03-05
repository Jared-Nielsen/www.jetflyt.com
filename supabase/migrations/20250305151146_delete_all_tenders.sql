-- Delete all FBO tenders first due to foreign key constraints
DELETE FROM fbo_tenders;

-- Then delete all tenders
DELETE FROM tenders;
