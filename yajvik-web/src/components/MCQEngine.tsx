import { useState } from 'react';
import { ChevronRight, Bookmark, AlertTriangle, CheckCircle2, Clock } from 'lucide-react';

const mockQuestions = [
  {
    id: 1,
    text: "A train running at the speed of 60 km/hr crosses a pole in 9 seconds. What is the length of the train?",
    options: ["120 metres", "180 metres", "324 metres", "150 metres"],
    correct: 3,
    explanation: "Speed = 60 * (5/18) m/sec = 50/3 m/sec. Length = Speed * Time = (50/3) * 9 = 150 metres.",
    difficulty: "Medium",
    topic: "Time & Distance"
  },
  {
    id: 2,
    text: "Which of the following is the capital of Australia?",
    options: ["Sydney", "Melbourne", "Canberra", "Perth"],
    correct: 2,
    explanation: "Canberra is the capital city of Australia.",
    difficulty: "Easy",
    topic: "Static GK"
  }
];

export default function MCQEngine() {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selectedOpt, setSelectedOpt] = useState<number | null>(null);
  const [submitted, setSubmitted] = useState(false);
  
  const question = mockQuestions[currentIdx];

  const handleSubmit = () => {
    if (selectedOpt !== null) {
      setSubmitted(true);
    }
  };

  const handleNext = () => {
    if (currentIdx < mockQuestions.length - 1) {
      setCurrentIdx(currentIdx + 1);
      setSelectedOpt(null);
      setSubmitted(false);
    }
  };

  return (
    <div className="max-w-3xl mx-auto py-8">
      <header className="flex justify-between items-center mb-6">
        <div className="flex items-center space-x-4">
          <div className="font-mono bg-surface border border-border px-3 py-1 rounded-lg text-sm font-bold flex items-center space-x-2">
            <Clock size={16} className="text-primary" />
            <span>00:15:42</span>
          </div>
          <span className="text-text-muted font-bold text-sm uppercase tracking-wider">
            Question {currentIdx + 1} / {mockQuestions.length}
          </span>
        </div>
        <button className="text-text-muted hover:text-white p-2"><Bookmark size={20} /></button>
      </header>

      <div className="surface-card p-8 md:p-10 mb-6 relative overflow-hidden">
        {/* Glow effect */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full blur-[80px]"></div>
        
        <div className="relative z-10">
          <div className="flex items-center space-x-2 mb-6">
            <span className="text-[10px] uppercase tracking-wider font-bold text-secondary bg-secondary/10 px-2 py-1 rounded">
              {question.difficulty}
            </span>
            <span className="text-[10px] uppercase tracking-wider font-bold text-text-muted bg-white/5 border border-border px-2 py-1 rounded">
              {question.topic}
            </span>
          </div>

          <h2 className="text-2xl font-bold text-white mb-8 leading-relaxed">
            {question.text}
          </h2>

          <div className="space-y-3">
            {question.options.map((opt, idx) => {
              const isSelected = selectedOpt === idx;
              const isCorrect = submitted && idx === question.correct;
              const isWrong = submitted && isSelected && idx !== question.correct;
              
              let classes = "w-full text-left p-4 rounded-xl border flex items-center justify-between transition-all ";
              if (!submitted) {
                classes += isSelected ? "border-primary bg-primary/10 glow-primary text-white" : "border-border bg-background hover:border-primary/50 text-text-muted hover:text-white";
              } else {
                if (isCorrect) classes += "border-secondary bg-secondary/10 text-white";
                else if (isWrong) classes += "border-danger bg-danger/10 text-white";
                else classes += "border-border bg-background opacity-50";
              }

              return (
                <button 
                  key={idx}
                  onClick={() => !submitted && setSelectedOpt(idx)}
                  className={classes}
                  disabled={submitted}
                >
                  <span className="font-medium text-lg flex items-center space-x-4">
                    <span className="w-8 h-8 rounded border border-current flex items-center justify-center text-sm font-bold opacity-70">
                      {String.fromCharCode(65 + idx)}
                    </span>
                    <span>{opt}</span>
                  </span>
                  {submitted && isCorrect && <CheckCircle2 className="text-secondary" />}
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {submitted && (
        <div className="surface-card p-6 border-secondary/30 bg-secondary/5 mb-6">
          <h3 className="font-bold text-white flex items-center space-x-2 mb-2">
            <CheckCircle2 className="text-secondary" />
            <span>Explanation</span>
          </h3>
          <p className="text-text-muted">{question.explanation}</p>
        </div>
      )}

      <div className="flex justify-between items-center">
        <button className="flex items-center space-x-2 text-text-muted hover:text-white font-medium px-4 py-2">
          <AlertTriangle size={18} />
          <span>Report Error</span>
        </button>
        
        {!submitted ? (
          <button 
            onClick={handleSubmit}
            disabled={selectedOpt === null}
            className="bg-primary disabled:opacity-50 text-white font-bold px-8 py-3 rounded-xl glow-primary transition-all"
          >
            Submit Answer
          </button>
        ) : (
          <button 
            onClick={handleNext}
            className="bg-white text-background font-bold px-8 py-3 rounded-xl hover:bg-gray-200 transition-colors flex items-center space-x-2"
          >
            <span>Next Question</span>
            <ChevronRight size={18} />
          </button>
        )}
      </div>
    </div>
  );
}
