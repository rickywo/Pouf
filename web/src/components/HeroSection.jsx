import { useState, useRef, useEffect } from 'react'
import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion'
import AppWindow from './AppWindow'
import FloatingCard from './FloatingCard'
import GlowBackground from './GlowBackground'

export default function HeroSection() {
  const containerRef = useRef(null)
  const [isLoaded, setIsLoaded] = useState(false)

  const mouseX = useMotionValue(0)
  const mouseY = useMotionValue(0)

  const springConfig = { damping: 25, stiffness: 150 }
  const rotateX = useSpring(useTransform(mouseY, [-0.5, 0.5], [8, -8]), springConfig)
  const rotateY = useSpring(useTransform(mouseX, [-0.5, 0.5], [-8, 8]), springConfig)

  useEffect(() => {
    const timer = setTimeout(() => setIsLoaded(true), 100)
    return () => clearTimeout(timer)
  }, [])

  const handleMouseMove = (e) => {
    if (!containerRef.current) return

    const rect = containerRef.current.getBoundingClientRect()
    const centerX = rect.left + rect.width / 2
    const centerY = rect.top + rect.height / 2

    const x = (e.clientX - centerX) / rect.width
    const y = (e.clientY - centerY) / rect.height

    mouseX.set(x)
    mouseY.set(y)
  }

  const handleMouseLeave = () => {
    mouseX.set(0)
    mouseY.set(0)
  }

  const floatingCards = [
    {
      id: 1,
      position: 'top-left',
      delay: 0.4,
      content: {
        title: 'AI Providers',
        value: '3',
        subtitle: 'supported',
        icon: '🤖',
        detail: 'Ollama · Gemini · Grok',
      },
    },
    {
      id: 2,
      position: 'top-right',
      delay: 0.6,
      content: {
        title: 'System-Wide',
        value: '∞',
        subtitle: 'apps supported',
        icon: '🌐',
        detail: 'Works everywhere',
      },
    },
    {
      id: 3,
      position: 'bottom-left',
      delay: 0.8,
      content: {
        title: 'Privacy First',
        value: '100%',
        subtitle: 'local option',
        icon: '🔒',
        detail: 'With Ollama',
      },
    },
    {
      id: 4,
      position: 'bottom-right',
      delay: 1.0,
      content: {
        title: 'One Shortcut',
        value: '⌘⌥/',
        subtitle: 'to enhance',
        icon: '⌨️',
        detail: 'Select & fix',
      },
    },
  ]

  return (
    <section
      ref={containerRef}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      className="relative min-h-screen w-full overflow-hidden flex items-center justify-center py-20"
    >
      <GlowBackground isLoaded={isLoaded} />

      <div className="relative z-10 w-full max-w-6xl mx-auto px-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: isLoaded ? 1 : 0, y: isLoaded ? 0 : 20 }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="text-center mb-16"
        >
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: isLoaded ? 1 : 0, scale: isLoaded ? 1 : 0.9 }}
            transition={{ duration: 0.5 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-pouf-purple/20 mb-8"
          >
            <span className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
            <span className="text-sm text-pouf-lavender/80">macOS Menu Bar App</span>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: isLoaded ? 1 : 0, scale: isLoaded ? 1 : 0.8 }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="mb-6"
          >
            <h1 className="text-6xl md:text-8xl font-extrabold text-gradient-pouf text-puffy tracking-tight">
              Pouf!
            </h1>
          </motion.div>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: isLoaded ? 1 : 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
            className="text-xl md:text-2xl text-white/90 max-w-2xl mx-auto mb-4 font-semibold"
          >
            System-Wide AI Text Enhancement
          </motion.p>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: isLoaded ? 1 : 0 }}
            transition={{ duration: 0.5, delay: 0.4 }}
            className="text-base md:text-lg text-pouf-lavender/60 max-w-xl mx-auto"
          >
            Select any text, press{' '}
            <kbd className="px-2 py-1 mx-1 rounded-lg bg-pouf-purple/20 text-pouf-lavender border border-pouf-purple/30 font-mono text-sm">
              ⌘⌥/
            </kbd>{' '}
            and watch it transform into polished, professional writing.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: isLoaded ? 1 : 0, y: isLoaded ? 0 : 10 }}
            transition={{ duration: 0.5, delay: 0.5 }}
            className="flex items-center justify-center gap-4 mt-10"
          >
            <button className="group px-8 py-4 rounded-2xl bg-gradient-to-r from-pouf-purple to-pouf-purple-dark text-white font-semibold hover:shadow-glow-md transition-all duration-300 hover:scale-105">
              <span className="flex items-center gap-2">
                Download for macOS
                <motion.span
                  animate={{ x: [0, 4, 0] }}
                  transition={{ duration: 1.5, repeat: Infinity }}
                >
                  →
                </motion.span>
              </span>
            </button>
            <a
              href="https://github.com/rickywo/Pouf"
              target="_blank"
              rel="noopener noreferrer"
              className="px-8 py-4 rounded-2xl bg-white/5 border border-white/10 text-white/80 font-semibold hover:bg-white/10 hover:border-pouf-purple/30 transition-all duration-300 flex items-center gap-2"
            >
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              View on GitHub
            </a>
          </motion.div>
        </motion.div>

        <div className="perspective-1000 relative">
          <motion.div
            style={{
              rotateX,
              rotateY,
              transformStyle: 'preserve-3d',
            }}
            className="relative"
          >
            {floatingCards.map((card) => (
              <FloatingCard
                key={card.id}
                position={card.position}
                delay={card.delay}
                content={card.content}
                isLoaded={isLoaded}
              />
            ))}

            <motion.div
              initial={{ opacity: 0, y: 60, scale: 0.95 }}
              animate={{
                opacity: isLoaded ? 1 : 0,
                y: isLoaded ? 0 : 60,
                scale: isLoaded ? 1 : 0.95,
              }}
              transition={{ duration: 1, delay: 0.3, ease: [0.16, 1, 0.3, 1] }}
            >
              <AppWindow />
            </motion.div>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: isLoaded ? 1 : 0 }}
          transition={{ duration: 0.5, delay: 1.2 }}
          className="mt-20 text-center"
        >
          <p className="text-sm text-pouf-lavender/40 mb-6">Powered by your choice of AI</p>
          <div className="flex items-center justify-center gap-12">
            <motion.div
              className="text-center group cursor-pointer"
              whileHover={{ scale: 1.05 }}
            >
              <div className="w-14 h-14 mb-3 mx-auto flex items-center justify-center rounded-2xl bg-white/5 group-hover:bg-white/10 transition-colors border border-white/10">
                <img
                  src="/icons/ollama-icon.svg"
                  alt="Ollama"
                  className="w-9 h-9 object-contain group-hover:scale-110 transition-transform"
                />
              </div>
              <div className="text-white/80 font-semibold group-hover:text-pouf-lavender transition-colors">
                Ollama
              </div>
              <div className="text-xs text-pouf-lavender/40">Local & Free</div>
            </motion.div>

            <motion.div
              className="text-center group cursor-pointer"
              whileHover={{ scale: 1.05 }}
            >
              <div className="w-14 h-14 mb-3 mx-auto flex items-center justify-center rounded-2xl bg-white/5 group-hover:bg-white/10 transition-colors border border-white/10">
                <img
                  src="/icons/gemini-icon.png"
                  alt="Gemini"
                  className="w-9 h-9 object-contain group-hover:scale-110 transition-transform"
                />
              </div>
              <div className="text-white/80 font-semibold group-hover:text-pouf-lavender transition-colors">
                Gemini
              </div>
              <div className="text-xs text-pouf-lavender/40">Google AI</div>
            </motion.div>

            <motion.div
              className="text-center group cursor-pointer"
              whileHover={{ scale: 1.05 }}
            >
              <div className="w-14 h-14 mb-3 mx-auto flex items-center justify-center rounded-2xl overflow-hidden">
                <img
                  src="/icons/grok-icon.svg"
                  alt="Grok"
                  className="w-14 h-14 object-cover group-hover:scale-110 transition-transform"
                />
              </div>
              <div className="text-white/80 font-semibold group-hover:text-pouf-lavender transition-colors">
                Grok
              </div>
              <div className="text-xs text-pouf-lavender/40">xAI</div>
            </motion.div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
