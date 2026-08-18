import { useEffect } from 'react';
import { Command } from 'cmdk';
import { Briefcase, BookOpen, Clock, FileText } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function GlobalSearch({ open, setOpen }: { open: boolean, setOpen: (open: boolean) => void }) {
  const navigate = useNavigate();

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        setOpen(true);
      }
    };

    document.addEventListener('keydown', down);
    return () => document.removeEventListener('keydown', down);
  }, [setOpen]);

  const handleSelect = (path: string) => {
    navigate(path);
    setOpen(false);
  };

  return (
    <Command.Dialog open={open} onOpenChange={setOpen} label="Global Command Menu">
      <Command.Input placeholder="Search jobs, exams, questions..." />
      <Command.List>
        <Command.Empty>No results found.</Command.Empty>

        <Command.Group heading="Suggestions">
          <Command.Item onSelect={() => handleSelect('/jobs')}>
            <Briefcase size={16} />
            <span>Browse Government Jobs</span>
          </Command.Item>
          <Command.Item onSelect={() => handleSelect('/preparation')}>
            <BookOpen size={16} />
            <span>Preparation Hub</span>
          </Command.Item>
        </Command.Group>

        <Command.Group heading="Quick Actions">
          <Command.Item onSelect={() => handleSelect('/tracker')}>
            <Clock size={16} />
            <span>View Application Tracker</span>
          </Command.Item>
          <Command.Item onSelect={() => handleSelect('/news')}>
            <FileText size={16} />
            <span>Read Current Affairs</span>
          </Command.Item>
        </Command.Group>
      </Command.List>
    </Command.Dialog>
  );
}
