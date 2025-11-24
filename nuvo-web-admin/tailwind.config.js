/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        nuvo: {
          green: '#2ECC71',    // Primario
          aqua: '#1ABC9C',     // Secundario
          purple: '#9B59B6',   // Acento
          dark: '#2C3E50',     // Textos
          gray: '#BDC3C7',     // Fondos
          light: '#F5F6FA'     // Background
        }
      }
    },
  },
  plugins: [],
}