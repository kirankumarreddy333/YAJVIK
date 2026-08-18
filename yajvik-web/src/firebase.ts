import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyBrjkFaR6ODnyjtLJjXq9WXAEeyDkTx40M",
  authDomain: "yajvik-649aa.firebaseapp.com",
  projectId: "yajvik-649aa",
  storageBucket: "yajvik-649aa.firebasestorage.app",
  messagingSenderId: "47006674990",
  appId: "1:47006674990:web:58e6da261683af8862afbf",
  measurementId: "G-NVPPFQ4V62"
};

const app = initializeApp(firebaseConfig);
export const analytics = getAnalytics(app);
export const auth = getAuth(app);
export default app;
