import { useState } from 'react';
import { ChevronDown, PlayCircle, FileText, CheckCircle2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

const syllabusData = [
  {
    subject: 'Aptitude',
    progress: 45,
    topics: [
      { name: 'Percentage', completed: true },
      { name: 'Profit & Loss', completed: true },
      { name: 'Ratio & Proportion', completed: false },
      { name: 'Time & Work', completed: false },
    ]
  },
  {
    subject: 'Reasoning',
    progress: 70,
    topics: [
      { name: 'Blood Relations', completed: true },
      { name: 'Coding-Decoding', completed: true },
      { name: 'Syllogism', completed: true },
      { name: 'Puzzles', completed: false },
    ]
  },
  {
    subject: 'General Awareness',
    progress: 20,
    topics: [
      { name: 'Indian Polity', completed: false },
      { name: 'Geography', completed: false },
      { name: 'History', completed: false },
    ]
  }
];

export default function Preparation() {
  const [expandedSubject, setExpandedSubject] = useState<string | null>('Aptitude');

  return (
    <div className="space-y-8 max-w-4xl mx-auto pb-8">
      <header className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-white">Preparation Hub</h1>
          <p className="text-text-muted mt-1">Master your syllabus with structured learning.</p>
        </div>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-1 space-y-4">
          <h2 className="font-bold text-lg text-white mb-2">Quick Actions</h2>
          <div className="surface-card p-4 flex items-center space-x-3 cursor-pointer hover:border-primary transition-colors">
            <div className="p-3 bg-secondary/10 text-secondary rounded-xl"><PlayCircle /></div>
            <div>
              <h3 className="font-bold text-white">Video Classes</h3>
              <p className="text-xs text-text-muted">Expert concepts</p>
            </div>
          </div>
          <div className="surface-card p-4 flex items-center space-x-3 cursor-pointer hover:border-primary transition-colors">
            <div className="p-3 bg-blue-500/10 text-blue-500 rounded-xl"><FileText /></div>
            <div>
              <h3 className="font-bold text-white">Previous Papers</h3>
              <p className="text-xs text-text-muted">Real past exams</p>
            </div>
          </div>
        </div>

        <div className="md:col-span-2">
          <h2 className="font-bold text-lg text-white mb-4">Complete Syllabus Explorer</h2>
          
          <div className="surface-card divide-y divide-border overflow-hidden">
            {syllabusData.map((data) => (
              <div key={data.subject}>
                <button 
                  onClick={() => setExpandedSubject(expandedSubject === data.subject ? null : data.subject)}
                  className="w-full p-5 flex items-center justify-between hover:bg-white/5 transition-colors"
                >
                  <div className="flex-1 text-left">
                    <h3 className="font-bold text-lg text-white">{data.subject}</h3>
                    <div className="flex items-center space-x-4 mt-2">
                      <div className="flex-1 max-w-[200px] h-1.5 bg-background rounded-full overflow-hidden border border-border">
                        <div className="h-full bg-gradient-to-r from-primary to-secondary" style={{ width: `${data.progress}%` }} />
                      </div>
                      <span className="text-xs font-bold text-text-muted">{data.progress}%</span>
                    </div>
                  </div>
                  <ChevronDown className={`text-text-muted transition-transform ${expandedSubject === data.subject ? 'rotate-180' : ''}`} />
                </button>

                <AnimatePresence>
                  {expandedSubject === data.subject && (
                    <motion.div 
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      className="bg-background/50 border-t border-border overflow-hidden"
                    >
                      <div className="p-4 space-y-2">
                        {data.topics.map(topic => (
                          <div key={topic.name} className="flex justify-between items-center p-3 rounded-xl hover:bg-surface cursor-pointer group transition-colors">
                            <div className="flex items-center space-x-3">
                              {topic.completed ? (
                                <CheckCircle2 className="text-secondary" size={18} />
                              ) : (
                                <div className="w-4 h-4 rounded-full border-2 border-border group-hover:border-primary transition-colors" />
                              )}
                              <span className={`font-medium ${topic.completed ? 'text-text-muted' : 'text-white'}`}>{topic.name}</span>
                            </div>
                            <div className="flex space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                              <button className="text-xs font-bold bg-primary/10 text-primary px-3 py-1.5 rounded-lg">Practice</button>
                            </div>
                          </div>
                        ))}
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
