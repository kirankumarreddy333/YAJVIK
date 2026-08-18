import MCQEngine from '../components/MCQEngine';

export default function MockTests() {
  return (
    <div className="space-y-6">
      <header className="mb-6">
        <h1 className="text-3xl font-bold text-white">Full Mock Test</h1>
        <p className="text-text-muted mt-1">SSC CGL Tier 1 Previous Year Paper</p>
      </header>
      <MCQEngine />
    </div>
  );
}
