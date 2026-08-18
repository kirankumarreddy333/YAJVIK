import { useState } from 'react';
import { Bookmark, Send } from 'lucide-react';

export default function Tracker() {
  const [activeTab, setActiveTab] = useState<'applied' | 'bookmarked'>('bookmarked');

  return (
    <div className="p-5 md:p-8 max-w-4xl mx-auto space-y-6">
      <header className="mb-6">
        <h1 className="text-2xl font-bold">Application Tracker</h1>
        <p className="text-gray-500 mt-1">Keep track of your applications and saved jobs.</p>
      </header>

      <div className="flex space-x-2 bg-white dark:bg-[#15141F] p-1 rounded-xl border border-[#E7E5F0] dark:border-[#262436]">
        <button
          onClick={() => setActiveTab('bookmarked')}
          className={`flex-1 flex justify-center items-center space-x-2 py-2 rounded-lg font-semibold transition-all ${
            activeTab === 'bookmarked' ? 'bg-[#6C5CE7] text-white shadow-sm' : 'text-gray-500 hover:bg-black/5 dark:hover:bg-white/5'
          }`}
        >
          <Bookmark size={18} fill={activeTab === 'bookmarked' ? 'currentColor' : 'none'} />
          <span>Bookmarked</span>
        </button>
        <button
          onClick={() => setActiveTab('applied')}
          className={`flex-1 flex justify-center items-center space-x-2 py-2 rounded-lg font-semibold transition-all ${
            activeTab === 'applied' ? 'bg-[#6C5CE7] text-white shadow-sm' : 'text-gray-500 hover:bg-black/5 dark:hover:bg-white/5'
          }`}
        >
          <Send size={18} />
          <span>Applied</span>
        </button>
      </div>

      <div className="surface-card p-10 flex flex-col items-center justify-center text-center mt-8">
        <div className="w-16 h-16 bg-gray-100 dark:bg-[#262436] rounded-full flex items-center justify-center mb-4 text-gray-400">
          {activeTab === 'bookmarked' ? <Bookmark size={32} /> : <Send size={32} />}
        </div>
        <h3 className="text-lg font-bold">
          No {activeTab} jobs yet
        </h3>
        <p className="text-gray-500 mt-2 max-w-sm">
          {activeTab === 'bookmarked' 
            ? "When you bookmark a job, it will appear here so you can easily find it later."
            : "Jobs you apply to will be tracked here."}
        </p>
      </div>
    </div>
  );
}
