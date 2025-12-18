import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'

export default function AppWindow() {
  const [isEnhancing, setIsEnhancing] = useState(false)
  const [showAfter, setShowAfter] = useState(false)
  const [cycleCount, setCycleCount] = useState(0)

  const examples = [
    {
      before: "hey boss, i cant come today, im sick and need to rest",
      after: "Hi, I won't be able to make it in today as I'm feeling unwell and need to rest.",
      app: "Mail",
    },
    {
      before: "the meeting went good we talked about stuff and made some descisions",
      after: "The meeting went well. We discussed key topics and reached several important decisions.",
      app: "Notes",
    },
    {
      before: "can u send me the file asap its urgent thx",
      after: "Could you please send me the file as soon as possible? It's urgent. Thank you.",
      app: "Slack",
    },
  ]

  const currentExample = examples[cycleCount % examples.length]

  useEffect(() => {
    const runCycle = () => {
      setShowAfter(false)
      setIsEnhancing(false)

      const enhanceTimer = setTimeout(() => {
        setIsEnhancing(true)
      }, 2000)

      const resultTimer = setTimeout(() => {
        setIsEnhancing(false)
        setShowAfter(true)
      }, 3500)

      const nextCycleTimer = setTimeout(() => {
        setCycleCount((c) => c + 1)
      }, 7000)

      return () => {
        clearTimeout(enhanceTimer)
        clearTimeout(resultTimer)
        clearTimeout(nextCycleTimer)
      }
    }

    const cleanup = runCycle()
    return cleanup
  }, [cycleCount])

  return (
    <div className="glass-panel glow-border p-1 mx-auto max-w-4xl">
      <div className="flex items-center gap-2 px-4 py-3 border-b border-white/5">
        <div className="flex gap-2">
          <span className="w-3 h-3 rounded-full bg-[#ff5f57]" />
          <span className="w-3 h-3 rounded-full bg-[#febc2e]" />
          <span className="w-3 h-3 rounded-full bg-[#28c840]" />
        </div>
        <div className="flex-1 flex justify-center">
          <div className="px-4 py-1 rounded-lg bg-white/5 text-xs text-pouf-lavender/50 font-medium">
            {currentExample.app}
          </div>
        </div>
        <div className="w-16" />
      </div>

      <div className="relative h-[400px] p-6">
        <div className="absolute top-4 right-4 flex items-center gap-2">
          <motion.div
            className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-white/5 border border-white/10"
            animate={isEnhancing ? { borderColor: 'rgba(167, 139, 250, 0.5)' } : {}}
          >
            <div className="w-2 h-2 rounded-full bg-green-400" />
            <span className="text-xs text-pouf-lavender/60 font-medium">Pouf Active</span>
          </motion.div>
        </div>

        <div className="max-w-2xl mx-auto pt-8">
          <div className="mb-4 text-sm text-pouf-lavender/40">To: manager@company.com</div>
          <div className="mb-6 text-sm text-pouf-lavender/40">Subject: Out of Office</div>

          <div className="relative min-h-[120px]">
            <AnimatePresence mode="wait">
              <motion.div
                key={`${cycleCount}-${showAfter}`}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
                className={`text-lg leading-relaxed ${
                  showAfter ? 'text-white' : 'text-white/70'
                }`}
              >
                <span
                  className={`${
                    isEnhancing
                      ? 'bg-pouf-purple/20 px-1 rounded-lg'
                      : showAfter
                        ? 'bg-green-500/10 px-1 rounded-lg'
                        : ''
                  } transition-colors duration-300`}
                >
                  {showAfter ? currentExample.after : currentExample.before}
                </span>
              </motion.div>
            </AnimatePresence>

            {isEnhancing && (
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0 }}
                className="absolute -bottom-16 left-0 right-0 flex justify-center"
              >
                <div className="flex items-center gap-3 px-5 py-2.5 rounded-2xl bg-gradient-to-r from-pouf-purple/20 to-pouf-pink/20 border border-pouf-purple/30">
                  <motion.div
                    className="w-4 h-4 border-2 border-pouf-lavender border-t-transparent rounded-full"
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
                  />
                  <span className="text-sm text-pouf-lavender font-medium">Enhancing with AI...</span>
                </div>
              </motion.div>
            )}
          </div>

          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5 }}
            className="mt-20 flex items-center justify-center gap-4"
          >
            <div className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-white/5 border border-white/10">
              <span className="text-xs text-pouf-lavender/40">Press</span>
              <div className="flex gap-1">
                <kbd className="px-2 py-1 rounded-lg bg-pouf-purple/20 text-xs text-pouf-lavender font-mono border border-pouf-purple/20">
                  ⌘
                </kbd>
                <kbd className="px-2 py-1 rounded-lg bg-pouf-purple/20 text-xs text-pouf-lavender font-mono border border-pouf-purple/20">
                  ⌥
                </kbd>
                <kbd className="px-2 py-1 rounded-lg bg-pouf-purple/20 text-xs text-pouf-lavender font-mono border border-pouf-purple/20">
                  /
                </kbd>
              </div>
              <span className="text-xs text-pouf-lavender/40">to enhance</span>
            </div>
          </motion.div>
        </div>

        <div className="absolute bottom-4 left-4 right-4 flex justify-between items-center">
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2">
              <div className="w-7 h-7 rounded-lg bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors cursor-pointer">
                <span className="text-xs">📎</span>
              </div>
              <div className="w-7 h-7 rounded-lg bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors cursor-pointer">
                <span className="text-xs">🔗</span>
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <span className="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg font-medium bg-pouf-purple/20 text-pouf-lavender border border-pouf-purple/30">
              <img src="/icons/ollama-icon.svg" alt="Ollama" className="w-4 h-4" />
              Ollama
            </span>
            <span className="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg font-medium bg-white/5 text-pouf-lavender/40 hover:bg-white/10 transition-colors cursor-pointer">
              <img src="/icons/gemini-icon.png" alt="Gemini" className="w-4 h-4" />
              Gemini
            </span>
            <span className="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg font-medium bg-white/5 text-pouf-lavender/40 hover:bg-white/10 transition-colors cursor-pointer overflow-hidden">
              <img src="/icons/grok-icon.svg" alt="Grok" className="w-4 h-4 rounded" />
              Grok
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}
