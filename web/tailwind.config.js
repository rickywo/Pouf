/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        dark: {
          900: '#1a1625',
          800: '#231d30',
          700: '#2d2640',
          600: '#382f4d',
        },
        pouf: {
          purple: {
            light: '#c4b5fd',
            DEFAULT: '#a78bfa',
            dark: '#8b5cf6',
            deeper: '#7c3aed',
          },
          lavender: '#ddd6fe',
          pink: '#f5d0fe',
          cream: '#faf5ff',
        },
        glow: {
          purple: '#a78bfa',
          lavender: '#c4b5fd',
          pink: '#f0abfc',
        }
      },
      animation: {
        'float-slow': 'float 6s ease-in-out infinite',
        'float-medium': 'float 5s ease-in-out infinite',
        'float-fast': 'float 4s ease-in-out infinite',
        'pulse-glow': 'pulseGlow 4s ease-in-out infinite',
        'fade-in-up': 'fadeInUp 1s ease-out forwards',
        'glow-expand': 'glowExpand 1.5s ease-out forwards',
        'sparkle': 'sparkle 2s ease-in-out infinite',
        'sparkle-delayed': 'sparkle 2s ease-in-out 0.5s infinite',
        'cloud-drift': 'cloudDrift 20s ease-in-out infinite',
        'cloud-drift-slow': 'cloudDrift 30s ease-in-out infinite',
        'puff': 'puff 3s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' },
        },
        pulseGlow: {
          '0%, 100%': { opacity: '0.5', transform: 'scale(1)' },
          '50%': { opacity: '0.8', transform: 'scale(1.05)' },
        },
        fadeInUp: {
          '0%': { opacity: '0', transform: 'translateY(40px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        glowExpand: {
          '0%': { opacity: '0', transform: 'scale(0.8)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
        sparkle: {
          '0%, 100%': { opacity: '0', transform: 'scale(0) rotate(0deg)' },
          '50%': { opacity: '1', transform: 'scale(1) rotate(180deg)' },
        },
        cloudDrift: {
          '0%, 100%': { transform: 'translateX(0) translateY(0)' },
          '25%': { transform: 'translateX(10px) translateY(-5px)' },
          '50%': { transform: 'translateX(0) translateY(-10px)' },
          '75%': { transform: 'translateX(-10px) translateY(-5px)' },
        },
        puff: {
          '0%, 100%': { transform: 'scale(1)', opacity: '0.6' },
          '50%': { transform: 'scale(1.1)', opacity: '0.8' },
        },
      },
      backdropBlur: {
        xs: '2px',
      },
      boxShadow: {
        'glow-sm': '0 0 20px rgba(167, 139, 250, 0.3)',
        'glow-md': '0 0 40px rgba(167, 139, 250, 0.4)',
        'glow-lg': '0 0 60px rgba(167, 139, 250, 0.5)',
        'soft': '0 10px 40px -10px rgba(0, 0, 0, 0.3)',
      },
      fontFamily: {
        display: ['SF Pro Rounded', 'SF Pro Display', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
