import { Settings, LogOut, ChevronRight, BookOpen, Shield, CreditCard } from 'lucide-react';

export default function Profile() {
  const menuItems = [
    { icon: <BookOpen size={20} />, label: 'My Preparations', value: 'SSC, UPSC' },
    { icon: <CreditCard size={20} />, label: 'Subscription', value: 'Free Plan' },
    { icon: <Shield size={20} />, label: 'Privacy & Security', value: '' },
    { icon: <Settings size={20} />, label: 'App Settings', value: '' },
  ];

  return (
    <div className="p-5 md:p-8 max-w-4xl mx-auto space-y-6">
      <header className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Profile</h1>
        <button className="p-2 rounded-full hover:bg-black/5 dark:hover:bg-white/10">
          <Settings size={24} />
        </button>
      </header>

      {/* User Info Card */}
      <div className="surface-card p-6 flex items-center space-x-4">
        <div className="w-16 h-16 bg-gradient-to-br from-[#6C5CE7] to-[#00D2A0] rounded-full flex items-center justify-center text-white text-2xl font-bold">
          U
        </div>
        <div className="flex-1">
          <h2 className="text-xl font-bold">User Name</h2>
          <p className="text-gray-500 text-sm">user@example.com</p>
          <div className="mt-2 inline-flex items-center space-x-1 px-2 py-1 bg-gray-100 dark:bg-[#262436] rounded-md text-xs font-semibold text-gray-600 dark:text-gray-300">
            <span>🎓 B.Tech</span>
            <span className="mx-1">•</span>
            <span>📍 All India</span>
          </div>
        </div>
      </div>

      {/* Premium Banner */}
      <div className="bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 p-[1px] rounded-2xl">
        <div className="bg-white dark:bg-[#15141F] p-5 rounded-2xl flex justify-between items-center">
          <div>
            <h3 className="font-bold text-lg bg-gradient-to-r from-indigo-500 to-pink-500 bg-clip-text text-transparent">YAJVIK Premium</h3>
            <p className="text-sm text-gray-500 mt-1">Unlock ad-free experience and advanced analytics.</p>
          </div>
          <button className="bg-gradient-to-r from-indigo-500 to-pink-500 text-white px-4 py-2 rounded-xl font-semibold shadow-md shadow-pink-500/20 hover:opacity-90 transition-opacity">
            Upgrade
          </button>
        </div>
      </div>

      {/* Menu Items */}
      <div className="surface-card divide-y divide-gray-100 dark:divide-[#262436]">
        {menuItems.map((item, idx) => (
          <div key={idx} className="flex justify-between items-center p-4 hover:bg-black/5 dark:hover:bg-white/5 cursor-pointer transition-colors">
            <div className="flex items-center space-x-3">
              <div className="text-gray-400">{item.icon}</div>
              <span className="font-semibold">{item.label}</span>
            </div>
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span>{item.value}</span>
              <ChevronRight size={16} className="text-gray-400" />
            </div>
          </div>
        ))}
      </div>

      {/* Logout */}
      <button className="w-full surface-card p-4 flex items-center justify-center space-x-2 text-red-500 font-bold hover:bg-red-50 dark:hover:bg-red-500/10 transition-colors">
        <LogOut size={20} />
        <span>Log Out</span>
      </button>
    </div>
  );
}
