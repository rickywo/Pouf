import { motion } from 'framer-motion'

export default function GlowBackground({ isLoaded }) {
  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      <div
        className="absolute inset-0"
        style={{
          background: 'linear-gradient(180deg, #1a1625 0%, #231d30 50%, #2d2640 100%)',
        }}
      />

      <motion.div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[900px] h-[700px]"
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{
          opacity: isLoaded ? 1 : 0,
          scale: isLoaded ? 1 : 0.8,
        }}
        transition={{ duration: 1.5, ease: 'easeOut' }}
      >
        <motion.div
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[400px] rounded-full"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(196, 181, 253, 0.25) 0%, rgba(167, 139, 250, 0.15) 40%, transparent 70%)',
            filter: 'blur(60px)',
          }}
          animate={{
            scale: [1, 1.1, 1],
            opacity: [0.6, 0.8, 0.6],
          }}
          transition={{
            duration: 8,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        />

        <motion.div
          className="absolute top-[20%] left-[15%] w-[200px] h-[150px] rounded-full animate-cloud-drift"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(255, 255, 255, 0.15) 0%, rgba(196, 181, 253, 0.1) 50%, transparent 70%)',
            filter: 'blur(30px)',
          }}
          animate={{
            scale: [1, 1.15, 1],
            opacity: [0.4, 0.6, 0.4],
          }}
          transition={{
            duration: 6,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
        />

        <motion.div
          className="absolute top-[30%] right-[20%] w-[180px] h-[120px] rounded-full animate-cloud-drift-slow"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(245, 208, 254, 0.2) 0%, rgba(196, 181, 253, 0.1) 50%, transparent 70%)',
            filter: 'blur(25px)',
          }}
          animate={{
            scale: [1, 1.2, 1],
            opacity: [0.3, 0.5, 0.3],
          }}
          transition={{
            duration: 7,
            repeat: Infinity,
            ease: 'easeInOut',
            delay: 1,
          }}
        />

        <motion.div
          className="absolute bottom-[25%] left-[25%] w-[160px] h-[100px] rounded-full"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(167, 139, 250, 0.2) 0%, transparent 70%)',
            filter: 'blur(20px)',
          }}
          animate={{
            x: [0, 20, 0],
            y: [0, -15, 0],
            scale: [1, 1.1, 1],
          }}
          transition={{
            duration: 9,
            repeat: Infinity,
            ease: 'easeInOut',
            delay: 2,
          }}
        />

        <motion.div
          className="absolute bottom-[30%] right-[15%] w-[140px] h-[90px] rounded-full"
          style={{
            background: 'radial-gradient(ellipse at center, rgba(240, 171, 252, 0.15) 0%, transparent 70%)',
            filter: 'blur(25px)',
          }}
          animate={{
            x: [0, -15, 0],
            y: [0, 10, 0],
            scale: [1, 1.15, 1],
          }}
          transition={{
            duration: 8,
            repeat: Infinity,
            ease: 'easeInOut',
            delay: 0.5,
          }}
        />
      </motion.div>

      <Sparkle className="top-[15%] left-[20%]" delay={0} />
      <Sparkle className="top-[25%] right-[15%]" delay={0.5} size="sm" />
      <Sparkle className="bottom-[20%] left-[10%]" delay={1} size="sm" />
      <Sparkle className="bottom-[30%] right-[25%]" delay={1.5} />
      <Sparkle className="top-[40%] left-[8%]" delay={2} size="lg" />
      <Sparkle className="top-[35%] right-[8%]" delay={2.5} />

      <div
        className="absolute inset-0 opacity-[0.03]"
        style={{
          backgroundImage: `
            radial-gradient(circle at 2px 2px, rgba(255,255,255,0.5) 1px, transparent 0)
          `,
          backgroundSize: '40px 40px',
        }}
      />

      <motion.div
        className="absolute top-0 left-0 right-0 h-px"
        style={{
          background: 'linear-gradient(90deg, transparent, rgba(196, 181, 253, 0.5), transparent)',
        }}
        initial={{ scaleX: 0, opacity: 0 }}
        animate={{
          scaleX: isLoaded ? 1 : 0,
          opacity: isLoaded ? 1 : 0,
        }}
        transition={{ duration: 1, delay: 0.5 }}
      />
    </div>
  )
}

function Sparkle({ className, delay = 0, size = 'md' }) {
  const sizeClasses = {
    sm: 'w-2 h-2',
    md: 'w-3 h-3',
    lg: 'w-4 h-4',
  }

  return (
    <motion.div
      className={`absolute ${className}`}
      initial={{ opacity: 0, scale: 0 }}
      animate={{
        opacity: [0, 1, 0],
        scale: [0, 1, 0],
        rotate: [0, 180, 360],
      }}
      transition={{
        duration: 3,
        repeat: Infinity,
        delay,
        ease: 'easeInOut',
      }}
    >
      <svg
        className={`${sizeClasses[size]} text-white`}
        viewBox="0 0 24 24"
        fill="currentColor"
      >
        <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z" />
      </svg>
    </motion.div>
  )
}
