import { useState, useEffect } from 'react';
import { Search, SlidersHorizontal, Bookmark, ChevronDown, Check } from 'lucide-react';
import JobCard from '../components/JobCard';
import { motion, AnimatePresence } from 'framer-motion';

export default function Jobs() {
  const [jobs, setJobs] = useState([]);
  const [query, setQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState<string | null>(null);
  const [bookmarksOnly, setBookmarksOnly] = useState(false);
  const [bookmarkedIds, setBookmarkedIds] = useState<Set<string>>(new Set());
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    fetch('http://localhost:5000/api/jobs')
      .then((res) => res.json())
      .then((data) => setJobs(data))
      .catch((err) => console.error(err));
  }, []);

  const toggleBookmark = (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    setBookmarkedIds(prev => {
      const newSet = new Set(prev);
      if (newSet.has(id)) newSet.delete(id);
      else newSet.add(id);
      return newSet;
    });
  };

  const filteredJobs = jobs.filter((job: any) => {
    if (bookmarksOnly && !bookmarkedIds.has(job._id)) return false;
    if (categoryFilter && job.category !== categoryFilter) return false;
    if (query && !job.title.toLowerCase().includes(query.toLowerCase()) && !job.organization.toLowerCase().includes(query.toLowerCase())) return false;
    return true;
  });

  const categories = ['All', 'Engineering', 'Railway', 'Bank', 'State PSC', 'UPSC', 'Defence', 'Police', 'Teaching', 'Medical', 'PSU'];

  return (
    <div className="flex flex-col lg:flex-row gap-6 h-full">
      {/* Left Column: Main Content */}
      <div className="flex-1 space-y-6">
        <header className="flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-white">Government Jobs</h1>
            <p className="text-text-muted mt-1">Discover {jobs.length} verified opportunities</p>
          </div>
          <div className="flex space-x-2">
            <button 
              onClick={() => setBookmarksOnly(!bookmarksOnly)}
              className={`p-2.5 rounded-xl border transition-all ${
                bookmarksOnly 
                  ? 'border-primary bg-primary/10 text-primary glow-primary' 
                  : 'border-border bg-surface text-text-muted hover:text-white hover:border-border-hover'
              }`}
            >
              <Bookmark size={20} fill={bookmarksOnly ? 'currentColor' : 'none'} />
            </button>
            <button 
              onClick={() => setShowFilters(!showFilters)}
              className={`lg:hidden p-2.5 rounded-xl border transition-all ${
                showFilters
                  ? 'border-primary bg-primary/10 text-primary glow-primary' 
                  : 'border-border bg-surface text-text-muted hover:text-white hover:border-border-hover'
              }`}
            >
              <SlidersHorizontal size={20} />
            </button>
          </div>
        </header>

        {/* Search Bar */}
        <div className="relative group">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-text-muted group-focus-within:text-primary transition-colors" size={20} />
          <input 
            type="text" 
            placeholder="Search roles, organizations, exams..." 
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="w-full bg-surface border border-border hover:border-border-hover rounded-2xl py-4 pl-12 pr-4 text-white focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all shadow-lg shadow-black/10"
          />
        </div>

        {/* Horizontal Categories */}
        <div className="flex overflow-x-auto pb-2 -mx-4 px-4 md:mx-0 md:px-0 space-x-2 scrollbar-hide">
          {categories.map((c) => {
            const isSelected = (c === 'All' && !categoryFilter) || categoryFilter === c;
            return (
              <button
                key={c}
                onClick={() => setCategoryFilter(c === 'All' ? null : c)}
                className={`whitespace-nowrap px-4 py-2 rounded-xl text-sm font-semibold transition-all border ${
                  isSelected 
                    ? 'bg-primary border-primary text-white shadow-[0_0_15px_rgba(138,125,240,0.4)]' 
                    : 'bg-surface border-border text-text-muted hover:border-border-hover hover:text-white'
                }`}
              >
                {c}
              </button>
            );
          })}
        </div>

        {/* Job List */}
        <div className="space-y-4 pb-10">
          <AnimatePresence mode="popLayout">
            {filteredJobs.length === 0 ? (
              <motion.div 
                initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
                className="surface-card p-12 text-center flex flex-col items-center justify-center"
              >
                <div className="w-16 h-16 bg-white/5 rounded-full flex items-center justify-center mb-4 text-text-muted">
                  <Search size={32} />
                </div>
                <h3 className="text-xl font-bold text-white mb-2">No jobs found</h3>
                <p className="text-text-muted">Try adjusting your search or filters.</p>
                <button 
                  onClick={() => { setQuery(''); setCategoryFilter(null); setBookmarksOnly(false); }}
                  className="mt-6 text-primary font-bold hover:underline"
                >
                  Clear all filters
                </button>
              </motion.div>
            ) : (
              filteredJobs.map((job: any) => (
                <motion.div
                  layout
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.95 }}
                  transition={{ duration: 0.2 }}
                  key={job._id}
                >
                  <JobCard 
                    job={job}
                    isBookmarked={bookmarkedIds.has(job._id)}
                    onBookmarkTap={(e) => toggleBookmark(e, job._id)}
                    onClick={() => console.log('Navigate to Job Detail', job._id)}
                  />
                </motion.div>
              ))
            )}
          </AnimatePresence>
        </div>
      </div>

      {/* Right Column: Advanced Filters (Desktop Sidebar / Mobile Modal) */}
      <AnimatePresence>
        {(showFilters || (typeof window !== 'undefined' && window.innerWidth >= 1024)) && (
          <motion.div 
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 20 }}
            className={`
              lg:w-80 lg:block lg:sticky lg:top-8 h-fit
              ${showFilters ? 'fixed inset-0 z-50 bg-background/95 backdrop-blur-md p-4 overflow-y-auto' : 'hidden'}
            `}
          >
            {showFilters && (
              <div className="flex justify-between items-center mb-6 lg:hidden">
                <h2 className="text-xl font-bold text-white">Filters</h2>
                <button onClick={() => setShowFilters(false)} className="text-text-muted">Close</button>
              </div>
            )}
            
            <div className="surface-card p-6 space-y-8">
              <div className="flex items-center space-x-2 text-white font-bold text-lg mb-4">
                <SlidersHorizontal size={20} className="text-primary" />
                <h2>Advanced Filters</h2>
              </div>

              {/* Filter Section: Govt Type */}
              <FilterSection title="Government Type" options={['Central Govt', 'State Govt', 'PSU']} />
              
              {/* Filter Section: Qualification */}
              <FilterSection title="Qualification" options={['10th Pass', '12th Pass', 'Diploma', 'Graduation', 'B.Tech / BE', 'Post Graduation']} />
              
              {/* Filter Section: Salary */}
              <FilterSection title="Salary Expectation" options={['Below ₹30k', '₹30k - ₹50k', '₹50k - ₹1 Lakh', 'Above ₹1 Lakh']} />

              <button className="w-full bg-primary hover:bg-primary/90 text-white font-bold py-3 rounded-xl transition-all glow-primary">
                Apply Filters
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

function FilterSection({ title, options }: { title: string, options: string[] }) {
  const [isOpen, setIsOpen] = useState(true);
  
  return (
    <div className="space-y-3 border-b border-border pb-6 last:border-0 last:pb-0">
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="flex justify-between items-center w-full text-left"
      >
        <h3 className="font-semibold text-text-muted">{title}</h3>
        <ChevronDown size={16} className={`text-text-muted transition-transform ${isOpen ? 'rotate-180' : ''}`} />
      </button>
      
      <AnimatePresence>
        {isOpen && (
          <motion.div 
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            className="space-y-2 overflow-hidden"
          >
            {options.map(opt => (
              <label key={opt} className="flex items-center space-x-3 cursor-pointer group">
                <div className="w-5 h-5 rounded border border-border group-hover:border-primary flex items-center justify-center bg-background/50 transition-colors">
                  <Check size={12} className="text-transparent" />
                </div>
                <span className="text-sm text-gray-300 group-hover:text-white transition-colors">{opt}</span>
              </label>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
