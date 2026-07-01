import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/capital-climbing/',
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.ts',
    // data/ contiene script standalone (es. crag_scoring.test.mjs) eseguiti con `node`,
    // non da vitest: usano process.exit e non sono suite vitest.
    exclude: ['**/node_modules/**', '**/dist/**', 'data/**'],
  },
})
