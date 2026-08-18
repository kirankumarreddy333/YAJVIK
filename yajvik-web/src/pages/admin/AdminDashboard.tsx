import { useState, useEffect } from 'react';
import { Plus, Edit, Trash2 } from 'lucide-react';

export default function AdminDashboard() {
  const [jobs, setJobs] = useState([]);

  useEffect(() => {
    fetch('http://localhost:5000/api/jobs')
      .then(res => res.json())
      .then(data => setJobs(data));
  }, []);

  return (
    <div className="p-5 md:p-8 max-w-6xl mx-auto space-y-6">
      <header className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold">Admin Dashboard</h1>
          <p className="text-gray-500">Manage jobs, users, and questions.</p>
        </div>
        <button className="bg-[#6C5CE7] text-white px-4 py-2 rounded-xl font-bold flex items-center space-x-2">
          <Plus size={20} />
          <span>Add Job</span>
        </button>
      </header>

      <div className="surface-card overflow-hidden">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-gray-50 dark:bg-[#1A1A24] border-b border-gray-200 dark:border-[#262436]">
              <th className="p-4 font-semibold text-gray-600 dark:text-gray-400">Title</th>
              <th className="p-4 font-semibold text-gray-600 dark:text-gray-400">Organization</th>
              <th className="p-4 font-semibold text-gray-600 dark:text-gray-400">Category</th>
              <th className="p-4 font-semibold text-gray-600 dark:text-gray-400">Vacancies</th>
              <th className="p-4 font-semibold text-gray-600 dark:text-gray-400">Actions</th>
            </tr>
          </thead>
          <tbody>
            {jobs.map((job: any) => (
              <tr key={job._id} className="border-b border-gray-100 dark:border-[#262436] hover:bg-gray-50 dark:hover:bg-white/5">
                <td className="p-4 font-medium">{job.title}</td>
                <td className="p-4"><span className="text-[#00D2A0] bg-[#00D2A0]/10 px-2 py-1 rounded-md text-xs font-bold">{job.organization}</span></td>
                <td className="p-4">{job.category}</td>
                <td className="p-4">{job.vacancies}</td>
                <td className="p-4 flex space-x-3">
                  <button className="text-blue-500 hover:text-blue-700"><Edit size={18} /></button>
                  <button className="text-red-500 hover:text-red-700"><Trash2 size={18} /></button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
