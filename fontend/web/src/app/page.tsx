'use client'
import { useState } from 'react';
// import axios from 'axios';

export default function Home() {
  // State สำหรับข้อมูล input
  const [gender, setGender] = useState<number | null>(null);
  const [race, setRace] = useState<number | null>(null);
  const [education, setEducation] = useState<number | null>(null);
  const [lunch, setLunch] = useState<number | null>(null);
  const [testPrep, setTestPrep] = useState<number | null>(null);

  // State สำหรับผลลัพธ์
  const [totalScore, setTotalScore] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const calculateScore = async () => {
    if ([gender, race, education, lunch, testPrep].includes(null)) {
      setError('Please fill in all fields');
      return;
    }

    setLoading(true);
    setError(null);
    setTotalScore(null);

    try {
      const response = await fetch('http://127.0.0.1:8000/api/student-score', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          gender,
          race,
          education,
          lunch,
          test_prep: testPrep,
        }),
      });

      if (!response.ok) {
        throw new Error('API request failed');
      }

      const data = await response.json();
      setTotalScore(data.total_score);
    } catch (err) {
      setError('Unable to connect to API or an error occurred');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 flex items-center justify-center p-4">
      <div className="bg-white/90 backdrop-blur-sm p-10 rounded-3xl shadow-xl border border-white/20 max-w-lg w-full">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full mx-auto mb-4 flex items-center justify-center">
            <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
          </div>
          <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-800 to-gray-600 bg-clip-text text-transparent">
            Student Score Calculator
          </h1>
          <p className="text-gray-500 mt-2">Predict academic performance based on student profile</p>
        </div>

        <div className="space-y-6">
          {/* Gender */}
          <div className="group">
            <label className="block text-sm font-semibold text-gray-700 mb-3">
              Gender
            </label>
            <select
              value={gender ?? ''}
              onChange={(e) => setGender(Number(e.target.value))}
              className="w-full px-4 py-3 bg-gray-50/50 border-2 border-gray-200/50 rounded-2xl focus:border-blue-400 focus:bg-white focus:outline-none transition-all duration-300 hover:border-gray-300 group-hover:shadow-md"
            >
              <option value="" disabled>Select gender</option>
              <option value={1}>Female</option>
              <option value={2}>Male</option>
            </select>
          </div>

          {/* Race */}
          <div className="group">
            <label className="block text-sm font-semibold text-gray-700 mb-3">
              Race/Ethnicity
            </label>
            <select
              value={race ?? ''}
              onChange={(e) => setRace(Number(e.target.value))}
              className="w-full px-4 py-3 bg-gray-50/50 border-2 border-gray-200/50 rounded-2xl focus:border-blue-400 focus:bg-white focus:outline-none transition-all duration-300 hover:border-gray-300 group-hover:shadow-md"
            >
              <option value="" disabled>Select race/ethnicity</option>
              <option value={1}>Group A</option>
              <option value={2}>Group B</option>
              <option value={3}>Group C</option>
              <option value={4}>Group D</option>
              <option value={5}>Group E</option>
            </select>
          </div>

          {/* Education */}
          <div className="group">
            <label className="block text-sm font-semibold text-gray-700 mb-3">
              Parental Level of Education
            </label>
            <select
              value={education ?? ''}
              onChange={(e) => setEducation(Number(e.target.value))}
              className="w-full px-4 py-3 bg-gray-50/50 border-2 border-gray-200/50 rounded-2xl focus:border-blue-400 focus:bg-white focus:outline-none transition-all duration-300 hover:border-gray-300 group-hover:shadow-md"
            >
              <option value="" disabled>Select parental education level</option>
              <option value={1}>Some High School</option>
              <option value={2}>High School</option>
              <option value={3}>Associate's Degree</option>
              <option value={4}>Some College</option>
              <option value={5}>Bachelor's Degree</option>
              <option value={6}>Master's Degree</option>
            </select>
          </div>

          {/* Lunch */}
          <div className="group">
            <label className="block text-sm font-semibold text-gray-700 mb-3">
              Lunch Program
            </label>
            <select
              value={lunch ?? ''}
              onChange={(e) => setLunch(Number(e.target.value))}
              className="w-full px-4 py-3 bg-gray-50/50 border-2 border-gray-200/50 rounded-2xl focus:border-blue-400 focus:bg-white focus:outline-none transition-all duration-300 hover:border-gray-300 group-hover:shadow-md"
            >
              <option value="" disabled>Select lunch program</option>
              <option value={2}>Free/Reduced</option>
              <option value={1}>Standard</option>
            </select>
          </div>

          {/* Test Prep */}
          <div className="group">
            <label className="block text-sm font-semibold text-gray-700 mb-3">
              Test Preparation Course
            </label>
            <select
              value={testPrep ?? ''}
              onChange={(e) => setTestPrep(Number(e.target.value))}
              className="w-full px-4 py-3 bg-gray-50/50 border-2 border-gray-200/50 rounded-2xl focus:border-blue-400 focus:bg-white focus:outline-none transition-all duration-300 hover:border-gray-300 group-hover:shadow-md"
            >
              <option value="" disabled>Select test preparation status</option>
              <option value={1}>None</option>
              <option value={2}>Completed</option>
            </select>
          </div>
        </div>

        <button
          onClick={calculateScore}
          disabled={loading || [gender, race, education, lunch, testPrep].includes(null)}
          className="mt-8 w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white font-bold py-4 px-6 rounded-2xl hover:from-blue-600 hover:to-purple-700 transition-all duration-300 transform hover:scale-[1.02] hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
        >
          {loading ? (
            <div className="flex items-center justify-center">
              <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Calculating...
            </div>
          ) : (
            'Calculate Score'
          )}
        </button>

        {error && (
          <div className="mt-6 p-4 bg-red-50/80 text-red-700 border-l-4 border-red-400 rounded-2xl backdrop-blur-sm">
            <div className="flex items-center">
              <svg className="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
              {error}
            </div>
          </div>
        )}

        {totalScore !== null && (
          <div className="mt-8 p-8 bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-200/50 rounded-3xl backdrop-blur-sm shadow-inner">
            <div className="text-center">
              <div className="w-20 h-20 bg-gradient-to-r from-green-400 to-emerald-500 rounded-full mx-auto mb-4 flex items-center justify-center">
                <svg className="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h2 className="text-xl font-bold text-gray-800 mb-2">Predicted Total Score</h2>
              <div className="text-4xl font-black bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                {totalScore}
                <span className="text-lg text-gray-500 font-normal"> / 300</span>
              </div>
              <div className="mt-4 bg-gray-200 rounded-full h-3 overflow-hidden">
                <div 
                  className="h-full bg-gradient-to-r from-green-400 to-emerald-500 rounded-full transition-all duration-1000 ease-out"
                  style={{ width: `${(totalScore / 300) * 100}%` }}
                ></div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}