import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import Layout from "./components/Layout";
import Home from "./pages/Home";
import Dashboard from "./pages/Dashboard";
import ReporteAcademico from "./pages/ReporteAcademico";
import ControlEscolar from "./pages/ControlEscolar";
import Finanzas from "./pages/Finanzas";

function App() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="academico" element={<ReporteAcademico />} />
        <Route path="control-escolar" element={<ControlEscolar />} />
        <Route path="finanzas" element={<Finanzas />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}

export default App;
