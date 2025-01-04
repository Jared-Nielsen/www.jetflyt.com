import { rm } from 'node:fs/promises';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = fileURLToPath(new URL('.', import.meta.url));
const projectRoot = join(__dirname, '..');

async function cleanDist() {
  try {
    await rm(join(projectRoot, 'dist'), { recursive: true, force: true });
    console.log('Successfully cleaned dist directory');
  } catch (err) {
    if (err.code !== 'ENOENT') {
      console.error('Error cleaning dist directory:', err);
      process.exit(1);
    }
  }
}

cleanDist();