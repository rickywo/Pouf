import { motion } from 'framer-motion'

const positionStyles = {
  'top-left': 'absolute -top-8 -left-16 z-20',
  'top-right': 'absolute -top-4 -right-20 z-20',
  'bottom-left': 'absolute -bottom-6 -left-12 z-20',
  'bottom-right': 'absolute -bottom-10 -right-16 z-20',
}

const floatVariants = {
  'top-left': {
    y: [0, -15, 0],
    x: [0, 5, 0],
    rotate: [0, 2, 0],
  },
  'top-right': {
    y: [0, -12, 0],
    x: [0, -8, 0],
    rotate: [0, -1.5, 0],
  },
  'bottom-left': {
    y: [0, -18, 0],
    x: [0, 6, 0],
    rotate: [0, 1.5, 0],
  },
  'bottom-right': {
    y: [0, -10, 0],
    x: [0, -5, 0],
    rotate: [0, -2, 0],
  },
}

const floatDurations = {
  'top-left': 5,
  'top-right': 6,
  'bottom-left': 7,
  'bottom-right': 5.5,
}

export default function FloatingCard({ position, delay, content, isLoaded }) {
  return (
    <motion.div
      className={positionStyles[position]}
      initial={{ opacity: 0, y: 30, scale: 0.9 }}
      animate={{
        opacity: isLoaded ? 1 : 0,
        y: isLoaded ? 0 : 30,
        scale: isLoaded ? 1 : 0.9,
      }}
      transition={{
        duration: 0.8,
        delay,
        ease: [0.16, 1, 0.3, 1],
      }}
    >
      <motion.div
        animate={floatVariants[position]}
        transition={{
          duration: floatDurations[position],
          repeat: Infinity,
          ease: 'easeInOut',
        }}
      >
        <div className="glass-card p-4 w-44 hover:bg-white/10 transition-all duration-300 cursor-pointer group hover:border-pouf-purple/30">
          <div className="flex items-center gap-2 mb-2">
            <span className="text-base">{content.icon}</span>
            <span className="text-xs text-pouf-lavender/60 font-semibold">
              {content.title}
            </span>
          </div>

          <div className="flex items-baseline gap-1.5">
            <span className="text-2xl font-bold text-white group-hover:text-pouf-lavender transition-colors">
              {content.value}
            </span>
            <span className="text-xs text-pouf-lavender/40">{content.subtitle}</span>
          </div>

          {content.detail && (
            <div className="mt-2 text-[10px] text-pouf-lavender/30 truncate">
              {content.detail}
            </div>
          )}

          <div className="mt-3 h-1 bg-white/10 rounded-full overflow-hidden">
            <motion.div
              className="h-full rounded-full"
              style={{
                background: 'linear-gradient(90deg, #c4b5fd, #a78bfa, #f5d0fe)',
              }}
              initial={{ width: '0%' }}
              animate={{ width: '100%' }}
              transition={{ duration: 1.5, delay: delay + 0.5, ease: 'easeOut' }}
            />
          </div>
        </div>
      </motion.div>
    </motion.div>
  )
}
