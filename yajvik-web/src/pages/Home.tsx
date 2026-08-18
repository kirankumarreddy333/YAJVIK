import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Flame, TrendingUp, BrainCircuit, Target, CheckCircle2, Circle, ArrowRight, Calendar, ShieldCheck } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function Home() {
  const navigate = useNavigate();
  const [stats] = useState({ streak: 12, progress: 68, questions: 1248, accuracy: 82 });

  useEffect(() => {
    // In production, these will be real API calls
    fetch('http://localhost:5000/api/jobs')
      .then(res => res.json())
      .catch(err => console.error(err));
  }, []);

  return (
    <div className="space-y-8 pb-8">
      {/* Premium Hero */}
      <div className="relative overflow-hidden surface-card p-8 md:p-10 border-0 bg-gradient-to-br from-surface to-background">
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full blur-[100px]"></div>
        <div className="relative z-10 space-y-4">
          <h2 className="text-3xl md:text-4xl font-bold">
            Good morning, <span className="text-primary glow-text">Kiran</span> 👋
          </h2>
          <p className="text-xl text-text-muted font-medium max-w-lg">
            Prepare smarter. <br/>
            Stay updated. <br/>
            <span className="text-white">Get your government job.</span>
          </p>
        </div>
      </div>

      {/* Premium Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Streak', value: `${stats.streak} Days`, icon: <Flame className="text-orange-500" /> },
          { label: 'Progress', value: `${stats.progress}%`, icon: <TrendingUp className="text-secondary" /> },
          { label: 'Questions', value: stats.questions.toLocaleString(), icon: <BrainCircuit className="text-primary" /> },
          { label: 'Accuracy', value: `${stats.accuracy}%`, icon: <Target className="text-blue-500" /> },
        ].map((stat, i) => (
          <motion.div 
            key={i}
            whileHover={{ y: -4 }}
            className="surface-card p-5 cursor-pointer flex flex-col justify-between"
          >
            <div className="flex justify-between items-start mb-4">
              <div className="p-2 bg-white/5 rounded-xl border border-border">{stat.icon}</div>
            </div>
            <div>
              <p className="text-sm font-medium text-text-muted">{stat.label}</p>
              <p className="text-2xl font-bold mt-1">{stat.value}</p>
            </div>
          </motion.div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Daily Questions Card */}
        <div className="lg:col-span-2 surface-card p-6 flex flex-col">
          <div className="flex justify-between items-center mb-6">
            <h3 className="text-xl font-bold flex items-center space-x-2">
              <BrainCircuit className="text-primary" />
              <span>Daily Questions</span>
            </h3>
            <div className="font-mono font-bold text-primary bg-primary/10 px-3 py-1 rounded-lg">
              2 / 4
            </div>
          </div>
          
          <p className="text-text-muted mb-4">Keep your streak alive.</p>
          
          <div className="w-full bg-white/5 rounded-full h-2 mb-6 border border-border">
            <div className="bg-primary h-2 rounded-full shadow-[0_0_10px_rgba(138,125,240,0.8)] transition-all" style={{ width: '50%' }}></div>
          </div>

          <div className="space-y-3 mb-8 flex-1">
            {['Aptitude', 'Reasoning'].map(t => (
              <div key={t} className="flex justify-between items-center p-3 rounded-xl bg-white/5 border border-border text-text-muted">
                <span className="font-medium text-white">{t}</span>
                <CheckCircle2 className="text-secondary" size={20} />
              </div>
            ))}
            {['Verbal', 'Current Affairs'].map(t => (
              <div key={t} className="flex justify-between items-center p-3 rounded-xl border border-border/50 text-text-muted">
                <span className="font-medium">{t}</span>
                <Circle size={20} />
              </div>
            ))}
          </div>

          <button className="w-full bg-primary hover:bg-primary/90 text-white font-bold py-4 rounded-xl flex justify-center items-center space-x-2 transition-all glow-primary">
            <span>Continue Practice</span>
            <ArrowRight size={20} />
          </button>
        </div>

        <div className="space-y-6">
          {/* Upcoming Results */}
          <div className="surface-card p-6">
            <div className="flex justify-between items-center mb-6">
              <h3 className="font-bold text-lg">Upcoming Results</h3>
            </div>
            
            <div className="space-y-4">
              <div className="p-4 rounded-xl border border-border bg-gradient-to-b from-white/5 to-transparent relative overflow-hidden group">
                <div className="absolute top-0 right-0 p-3 opacity-10 group-hover:opacity-20 transition-opacity">
                  <ShieldCheck size={64} />
                </div>
                <div className="relative z-10">
                  <h4 className="font-bold text-lg text-white">SSC CGL 2026</h4>
                  <p className="text-text-muted text-sm font-medium">Tier 1 Result</p>
                  
                  <div className="mt-4 flex items-center space-x-2 text-sm text-secondary bg-secondary/10 px-3 py-1.5 rounded-lg inline-flex font-mono">
                    <Calendar size={16} />
                    <span>Expected: 26 Aug 2026</span>
                  </div>
                  
                  <p className="mt-3 text-xs text-text-muted uppercase tracking-wider font-bold">
                    5 days remaining
                  </p>
                  
                  <button className="mt-4 w-full flex justify-between items-center text-sm font-bold text-primary hover:text-white transition-colors">
                    <span>View Result</span>
                    <ArrowRight size={16} />
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Quick Action - Mock Test */}
          <div className="surface-card p-6 bg-gradient-to-br from-primary/20 to-transparent border-primary/30">
            <h3 className="font-bold text-lg mb-2 text-white glow-text">Full Mock Test</h3>
            <p className="text-sm text-text-muted mb-4">Simulate the real exam environment with our latest full-length tests.</p>
            <button onClick={() => navigate('/mock-tests')} className="bg-white text-background font-bold px-4 py-2 rounded-lg w-full flex justify-center items-center space-x-2 hover:bg-gray-200 transition-colors">
              <Play size={16} />
              <span>Start Now</span>
            </button>
          </div>
        </div>
      </div>

    </div>
  );
}

function Play(props: any) {
  return (
    <svg {...props} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polygon points="6 3 20 12 6 21 6 3"/></svg>
  )
}
