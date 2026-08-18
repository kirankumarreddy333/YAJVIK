import { useState } from 'react';
import { Share2, Bookmark, ChevronUp, ChevronDown, Globe } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const MOCK_NEWS = [
  {
    id: 1,
    category: 'National',
    title: 'Union Cabinet Approves 3 Major Railway Projects',
    summary: 'The Union Cabinet chaired by PM Modi approved 3 multi-tracking railway projects with an estimated cost of ₹6,456 crore. These projects will improve logistics efficiency and reduce travel time.',
    source: 'PIB India',
    time: '2 hours ago',
    image: '🚆'
  },
  {
    id: 2,
    category: 'Science',
    title: 'ISRO Successfully Launches New Weather Satellite',
    summary: 'ISRO successfully placed the INSAT-3DS meteorological satellite into the geostationary transfer orbit. This will enhance weather forecasting capabilities and disaster warnings.',
    source: 'ISRO Official',
    time: '5 hours ago',
    image: '🚀'
  }
];

export default function NewsReels() {
  const [currentIndex, setCurrentIndex] = useState(0);

  const nextNews = () => {
    if (currentIndex < MOCK_NEWS.length - 1) setCurrentIndex(currentIndex + 1);
  };

  const prevNews = () => {
    if (currentIndex > 0) setCurrentIndex(currentIndex - 1);
  };

  const currentNews = MOCK_NEWS[currentIndex];

  return (
    <div className="h-[calc(100vh-8rem)] md:h-[calc(100vh-6rem)] w-full max-w-lg mx-auto relative flex flex-col justify-center pb-12">
      <div className="absolute right-[-40px] md:right-[-60px] top-1/2 -translate-y-1/2 flex flex-col space-y-4">
        <button 
          onClick={prevNews}
          disabled={currentIndex === 0}
          className="p-3 surface-card rounded-full disabled:opacity-30 hover:bg-white/10"
        >
          <ChevronUp size={24} />
        </button>
        <button 
          onClick={nextNews}
          disabled={currentIndex === MOCK_NEWS.length - 1}
          className="p-3 surface-card rounded-full disabled:opacity-30 hover:bg-white/10"
        >
          <ChevronDown size={24} />
        </button>
      </div>

      <AnimatePresence mode="wait">
        <motion.div 
          key={currentIndex}
          initial={{ opacity: 0, y: 50 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -50 }}
          transition={{ duration: 0.3 }}
          className="h-[80%] surface-card rounded-[2rem] overflow-hidden flex flex-col relative"
        >
          {/* Mock Image Area */}
          <div className="h-2/5 bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-6xl">
            {currentNews.image}
          </div>
          
          <div className="p-8 flex-1 flex flex-col">
            <div className="flex justify-between items-center mb-4">
              <span className="text-xs font-bold text-primary bg-primary/10 px-3 py-1.5 rounded-lg uppercase tracking-wider">
                {currentNews.category}
              </span>
              <div className="flex space-x-3 text-text-muted">
                <button className="hover:text-white"><Share2 size={20}/></button>
                <button className="hover:text-white"><Bookmark size={20}/></button>
              </div>
            </div>

            <h2 className="text-2xl md:text-3xl font-bold text-white leading-tight mb-4">
              {currentNews.title}
            </h2>
            
            <p className="text-text-muted text-lg leading-relaxed flex-1">
              {currentNews.summary}
            </p>

            <div className="mt-6 pt-4 border-t border-border flex justify-between items-center text-sm">
              <div className="flex items-center space-x-2 text-text-muted font-medium">
                <Globe size={16} />
                <span>{currentNews.source}</span>
              </div>
              <span className="text-text-muted">{currentNews.time}</span>
            </div>
            
            <button className="mt-6 w-full py-3 rounded-xl border border-border text-white font-bold hover:bg-white/5 transition-colors">
              Read Official Article
            </button>
          </div>
        </motion.div>
      </AnimatePresence>
      
      {/* Progress Dots */}
      <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex space-x-2">
        {MOCK_NEWS.map((_, idx) => (
          <div 
            key={idx} 
            className={`h-2 rounded-full transition-all ${idx === currentIndex ? 'w-6 bg-primary' : 'w-2 bg-border'}`} 
          />
        ))}
      </div>
    </div>
  );
}
