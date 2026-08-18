import { useState } from 'react';
import { Outlet, NavLink, useLocation } from 'react-router-dom';
import { Home, Briefcase, BookOpen, Clock, User, Settings, Globe, FileText, CheckCircle, Bell, Search, LayoutTemplate } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import GlobalSearch from '../components/GlobalSearch';

const MainLayout = () => {
  const location = useLocation();
  const [searchOpen, setSearchOpen] = useState(false);
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);

  const mainNav = [
    { name: 'Home', path: '/', icon: <Home size={20} /> },
    { name: 'Government Jobs', path: '/jobs', icon: <Briefcase size={20} /> },
    { name: 'Preparation', path: '/preparation', icon: <BookOpen size={20} /> },
    { name: 'Current Affairs', path: '/news', icon: <Globe size={20} /> },
    { name: 'Mock Tests', path: '/mock-tests', icon: <FileText size={20} /> },
    { name: 'Results', path: '/results', icon: <CheckCircle size={20} /> },
    { name: 'Tracker', path: '/tracker', icon: <Clock size={20} /> },
  ];

  const userNav = [
    { name: 'Profile', path: '/profile', icon: <User size={20} /> },
    { name: 'Settings', path: '/settings', icon: <Settings size={20} /> },
  ];

  return (
    <div className="flex h-screen overflow-hidden bg-background">
      <GlobalSearch open={searchOpen} setOpen={setSearchOpen} />

      {/* Premium Desktop Sidebar */}
      <motion.aside 
        animate={{ width: sidebarCollapsed ? 80 : 280 }}
        className="hidden md:flex flex-col border-r border-border nav-bar z-40 transition-all duration-300"
      >
        <div className="p-6 flex items-center justify-between">
          {!sidebarCollapsed && (
            <motion.h1 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="text-2xl font-[Montserrat] font-black tracking-widest text-primary glow-text"
            >
              YAJVIK
            </motion.h1>
          )}
          <button 
            onClick={() => setSidebarCollapsed(!sidebarCollapsed)}
            className="p-2 rounded-xl hover:bg-white/5 text-text-muted hover:text-white transition-colors"
          >
            <LayoutTemplate size={20} />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto py-4 px-3 space-y-8 scrollbar-hide">
          <ul className="space-y-1">
            {mainNav.map((item) => (
              <li key={item.path}>
                <NavLink
                  to={item.path}
                  title={sidebarCollapsed ? item.name : undefined}
                  className={({ isActive }) =>
                    `flex items-center space-x-3 px-3 py-3 rounded-xl transition-all duration-200 relative group overflow-hidden ${
                      isActive 
                        ? 'text-white font-medium' 
                        : 'text-text-muted hover:bg-white/5 hover:text-white'
                    }`
                  }
                >
                  {({ isActive }) => (
                    <>
                      {isActive && (
                        <motion.div
                          layoutId="sidebar-indicator"
                          className="absolute inset-0 bg-primary/10 border border-primary/20 rounded-xl glow-primary z-0"
                        />
                      )}
                      <div className="relative z-10 flex items-center space-x-3">
                        <span className={isActive ? 'text-primary drop-shadow-[0_0_8px_rgba(138,125,240,0.5)]' : ''}>
                          {item.icon}
                        </span>
                        {!sidebarCollapsed && (
                          <motion.span initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
                            {item.name}
                          </motion.span>
                        )}
                      </div>
                    </>
                  )}
                </NavLink>
              </li>
            ))}
          </ul>

          <div>
            {!sidebarCollapsed && (
              <div className="px-4 mb-2 text-xs font-semibold text-text-muted uppercase tracking-wider">Account</div>
            )}
            <ul className="space-y-1">
              {userNav.map((item) => (
                <li key={item.path}>
                  <NavLink
                    to={item.path}
                    title={sidebarCollapsed ? item.name : undefined}
                    className={({ isActive }) =>
                      `flex items-center space-x-3 px-3 py-3 rounded-xl transition-all duration-200 relative group overflow-hidden ${
                        isActive 
                          ? 'text-white font-medium' 
                          : 'text-text-muted hover:bg-white/5 hover:text-white'
                      }`
                    }
                  >
                    {({ isActive }) => (
                      <>
                        {isActive && (
                          <motion.div
                            layoutId="sidebar-indicator"
                            className="absolute inset-0 bg-primary/10 border border-primary/20 rounded-xl glow-primary z-0"
                          />
                        )}
                        <div className="relative z-10 flex items-center space-x-3">
                          <span className={isActive ? 'text-primary' : ''}>
                            {item.icon}
                          </span>
                          {!sidebarCollapsed && <span>{item.name}</span>}
                        </div>
                      </>
                    )}
                  </NavLink>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </motion.aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-h-0 overflow-hidden relative">
        {/* Top Navigation */}
        <header className="h-16 nav-bar border-b flex items-center justify-between px-4 md:px-8 z-30">
          <div className="flex items-center md:hidden">
            <h1 className="text-xl font-[Montserrat] font-black tracking-widest text-primary glow-text">YAJVIK</h1>
          </div>
          
          <div className="flex-1 flex justify-end md:justify-between items-center ml-4">
            <button 
              onClick={() => setSearchOpen(true)}
              className="hidden md:flex items-center space-x-2 bg-surface border border-border hover:border-border-hover px-4 py-2 rounded-xl text-text-muted transition-all w-64 lg:w-96"
            >
              <Search size={18} />
              <span className="flex-1 text-left text-sm">Search...</span>
              <div className="flex items-center space-x-1">
                <kbd className="bg-background border border-border rounded px-1.5 py-0.5 text-xs font-mono">⌘</kbd>
                <kbd className="bg-background border border-border rounded px-1.5 py-0.5 text-xs font-mono">K</kbd>
              </div>
            </button>
            <button onClick={() => setSearchOpen(true)} className="md:hidden p-2 text-text-muted hover:text-white">
              <Search size={20} />
            </button>

            <div className="flex items-center space-x-2 md:space-x-4">
              <button className="p-2 text-text-muted hover:text-white transition-colors relative">
                <Bell size={20} />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-danger rounded-full border-2 border-background"></span>
              </button>
              <div className="w-px h-6 bg-border mx-2 hidden md:block"></div>
              <button className="flex items-center space-x-2 p-1 pl-2 pr-4 border border-border hover:border-border-hover rounded-full transition-colors bg-surface">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-primary to-secondary flex items-center justify-center text-xs font-bold text-background">
                  U
                </div>
                <span className="text-sm font-medium hidden md:block">User</span>
              </button>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 overflow-y-auto p-4 md:p-8 pb-24 md:pb-8 relative">
          <AnimatePresence mode="wait">
            <motion.div
              key={location.pathname}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
              className="max-w-6xl mx-auto h-full"
            >
              <Outlet />
            </motion.div>
          </AnimatePresence>
        </main>

        {/* Mobile Bottom Navigation */}
        <nav className="md:hidden fixed bottom-0 w-full nav-bar border-t pb-safe pt-2 px-2 z-50">
          <ul className="flex justify-around items-center h-16">
            {[mainNav[0], mainNav[1], mainNav[2], mainNav[6], userNav[0]].map((item) => (
              <li key={item.path} className="flex-1">
                <NavLink
                  to={item.path}
                  className={({ isActive }) =>
                    `flex flex-col items-center justify-center w-full h-full space-y-1 transition-all ${
                      isActive ? 'text-primary glow-text' : 'text-text-muted'
                    }`
                  }
                >
                  {({ isActive }) => (
                    <>
                      <div className="relative">
                        {item.icon}
                        {isActive && (
                          <motion.div
                            layoutId="mobile-indicator"
                            className="absolute -top-3 left-1/2 -translate-x-1/2 w-8 h-1 bg-primary rounded-full glow-primary"
                          />
                        )}
                      </div>
                      <span className="text-[10px] font-medium">{item.name}</span>
                    </>
                  )}
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </div>
  );
};

export default MainLayout;
