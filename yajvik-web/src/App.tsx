import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Jobs from './pages/Jobs';
import Preparation from './pages/Preparation';
import Tracker from './pages/Tracker';
import Profile from './pages/Profile';
import AdminDashboard from './pages/admin/AdminDashboard';
import NewsReels from './pages/NewsReels';
import MockTests from './pages/MockTests';
import MainLayout from './layouts/MainLayout';
import './index.css';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route index element={<Home />} />
          <Route path="jobs" element={<Jobs />} />
          <Route path="preparation" element={<Preparation />} />
          <Route path="tracker" element={<Tracker />} />
          <Route path="profile" element={<Profile />} />
          <Route path="news" element={<NewsReels />} />
          <Route path="mock-tests" element={<MockTests />} />
        </Route>
        <Route path="/admin" element={<AdminDashboard />} />
      </Routes>
    </Router>
  );
}

export default App;
