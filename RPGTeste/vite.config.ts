import { defineConfig } from 'vite';
import { rpgjs, tiledMapFolderPlugin } from '@rpgjs/vite';
import startServer from './src/server';

export default defineConfig({
  base: './',
  plugins: [
    tiledMapFolderPlugin({
      sourceFolder: './src/tiled',      // Folder containing your TMX files
      publicPath: './map',               // Public URL path for maps
      buildOutputPath: 'map'    // Build output directory
    }),
    ...rpgjs({
      server: startServer
    })
  ], 
});
