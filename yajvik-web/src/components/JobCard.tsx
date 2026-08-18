import { Bookmark, MapPin, Building, ChevronRight } from 'lucide-react';

interface Job {
  _id: string;
  title: string;
  organization: string;
  state: string;
  vacancies: number;
  lastDate: string;
  category: string;
  salary?: string;
  qualification?: string;
}

interface JobCardProps {
  job: Job;
  onClick: () => void;
  onBookmarkTap: (e: React.MouseEvent) => void;
  isBookmarked?: boolean;
}

export default function JobCard({ job, onClick, onBookmarkTap, isBookmarked = false }: JobCardProps) {
  
  // Calculate status
  const daysLeft = Math.ceil((new Date(job.lastDate).getTime() - new Date().getTime()) / (1000 * 3600 * 24));
  let statusText = 'OPEN';
  let statusColor = 'text-secondary bg-secondary/10';
  
  if (daysLeft < 0) {
    statusText = 'CLOSED';
    statusColor = 'text-text-muted bg-white/5';
  } else if (daysLeft <= 5) {
    statusText = 'CLOSING SOON';
    statusColor = 'text-danger bg-danger/10';
  } else if (daysLeft >= 30) {
    statusText = 'NEW';
    statusColor = 'text-primary bg-primary/10';
  }

  return (
    <div 
      onClick={onClick}
      className="surface-card p-6 cursor-pointer hover:border-primary/50 transition-all group relative overflow-hidden"
    >
      <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 rounded-full blur-[50px] group-hover:bg-primary/10 transition-colors"></div>
      
      <div className="relative z-10">
        <div className="flex justify-between items-start mb-4">
          <div className="flex flex-wrap gap-2 mb-2">
            <span className={`text-[10px] font-bold px-2 py-1 rounded-md tracking-wider ${statusColor}`}>
              {statusText}
            </span>
            <span className="text-[10px] font-bold text-text-muted bg-white/5 border border-border px-2 py-1 rounded-md">
              {job.category}
            </span>
          </div>
          <button 
            onClick={onBookmarkTap}
            className={`p-2 rounded-full transition-all ${
              isBookmarked 
                ? 'text-primary bg-primary/10 glow-primary border border-primary/20' 
                : 'text-text-muted hover:text-white hover:bg-white/5'
            }`}
          >
            <Bookmark size={18} fill={isBookmarked ? 'currentColor' : 'none'} />
          </button>
        </div>

        <h4 className="font-bold text-xl leading-tight group-hover:text-primary transition-colors text-white mb-2">{job.title}</h4>
        
        <div className="space-y-2 mt-4">
          <div className="flex items-center space-x-2 text-sm text-text-muted">
            <Building size={16} />
            <span className="font-medium text-gray-300">{job.organization}</span>
          </div>
          <div className="flex items-center space-x-2 text-sm text-text-muted">
            <MapPin size={16} />
            <span>{job.state}</span>
          </div>
          {job.qualification && (
             <div className="flex items-center space-x-2 text-sm text-text-muted">
               <BookOpen size={16} />
               <span>{job.qualification}</span>
             </div>
          )}
        </div>

        <div className="mt-6 pt-4 border-t border-border flex justify-between items-center text-sm">
          <div className="flex space-x-4">
            <div className="flex flex-col">
              <span className="text-[10px] uppercase tracking-wider text-text-muted font-bold">Vacancies</span>
              <span className="font-semibold text-white">{job.vacancies}</span>
            </div>
            <div className="flex flex-col">
              <span className="text-[10px] uppercase tracking-wider text-text-muted font-bold">Last Date</span>
              <span className={`font-semibold ${daysLeft > 0 && daysLeft <= 5 ? 'text-danger' : 'text-white'}`}>
                {new Date(job.lastDate).toLocaleDateString()}
              </span>
            </div>
          </div>
          <div className="flex items-center space-x-1 text-primary group-hover:translate-x-1 transition-transform">
            <span className="font-bold text-sm hidden sm:block">View Details</span>
            <ChevronRight size={18} />
          </div>
        </div>
      </div>
    </div>
  );
}

function BookOpen(props: any) {
  return (
    <svg {...props} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/></svg>
  )
}
