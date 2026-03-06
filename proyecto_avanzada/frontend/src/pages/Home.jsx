import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
import { Bar } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Tooltip,
  Legend,
} from "chart.js";
import { API_BASE, formatNumber } from "../utils/api";

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Tooltip,
  Legend
);

function Home() {
  const [kpis, setKpis] = useState(null);
  const [rendimientoCarrera, setRendimientoCarrera] = useState([]);
  const [estatusInscripcion, setEstatusInscripcion] = useState([]);
  const [morososCount, setMorososCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetch = async () => {
      try {
        const [kpisRes, rendimientoRes, estatusRes, morososRes] =
          await Promise.all([
            axios.get(`${API_BASE}/api/dashboard/kpis`),
            axios.get(`${API_BASE}/api/vistas/vw_rendimiento_por_carrera`),
            axios.get(`${API_BASE}/api/control-escolar/estatus-inscripcion`),
            axios.get(`${API_BASE}/api/finanzas/morosidad`),
          ]);
        setKpis(kpisRes.data?.error ? null : kpisRes.data);
        setRendimientoCarrera(
          Array.isArray(rendimientoRes.data) ? rendimientoRes.data : []
        );
        setEstatusInscripcion(
          Array.isArray(estatusRes.data) ? estatusRes.data : []
        );
        const morosos = Array.isArray(morososRes.data) ? morososRes.data : [];
        setMorososCount(morosos.length);
      } catch (err) {
        console.error(err);
        setError("Error al cargar los datos.");
      } finally {
        setLoading(false);
      }
    };
    fetch();
  }, []);

  const rendimientoChartData = {
    labels: rendimientoCarrera.slice(0, 5).map((r) => r.carrera),
    datasets: [
      {
        label: "Promedio",
        backgroundColor: "#5e72e4",
        data: rendimientoCarrera
          .slice(0, 5)
          .map((r) => Number(r.promedio_general || 0)),
      },
    ],
  };

  return (
    <>
      <div className="header bg-gradient-primary pb-8 pt-5 pt-md-8">
        <div className="container-fluid">
          <div className="header-body">
            {error && (
              <div className="alert alert-danger mb-4" role="alert">
                {error}
              </div>
            )}
            <h1 className="text-white mb-4">Vista general</h1>
            <p className="text-white opacity-8 mb-4">
              Resumen de lo más importante de cada área. Usa el menú para ver el
              detalle completo.
            </p>

            <div className="row">
              <div className="col-xl-3 col-lg-6">
                <div className="card card-stats mb-4 mb-xl-0 shadow">
                  <div className="card-body">
                    <div className="row">
                      <div className="col">
                        <h5 className="card-title text-uppercase text-muted mb-0">
                          Rendimiento Global
                        </h5>
                        <span className="h2 font-weight-bold mb-0">
                          {kpis
                            ? formatNumber(kpis.rendimiento_global, 2)
                            : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-info text-white rounded-circle shadow">
                          <i className="fas fa-chart-bar" />
                        </div>
                      </div>
                    </div>
                    <Link to="/dashboard" className="text-sm text-primary mt-2 d-block">
                      Ver dashboard completo →
                    </Link>
                  </div>
                </div>
              </div>

              <div className="col-xl-3 col-lg-6">
                <div className="card card-stats mb-4 mb-xl-0 shadow">
                  <div className="card-body">
                    <div className="row">
                      <div className="col">
                        <h5 className="card-title text-uppercase text-muted mb-0">
                          Total de Alumnos
                        </h5>
                        <span className="h2 font-weight-bold mb-0">
                          {kpis ? formatNumber(kpis.total_alumnos) : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-orange text-white rounded-circle shadow">
                          <i className="fas fa-users" />
                        </div>
                      </div>
                    </div>
                    <Link to="/control-escolar" className="text-sm text-primary mt-2 d-block">
                      Ver lista de alumnos →
                    </Link>
                  </div>
                </div>
              </div>

              <div className="col-xl-3 col-lg-6">
                <div className="card card-stats mb-4 mb-xl-0 shadow">
                  <div className="card-body">
                    <div className="row">
                      <div className="col">
                        <h5 className="card-title text-uppercase text-muted mb-0">
                          Estatus de Pagos
                        </h5>
                        <span className="h2 font-weight-bold mb-0">
                          {kpis
                            ? `${formatNumber(
                                kpis.porcentaje_pagos_corriente,
                                2
                              )}%`
                            : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-green text-white rounded-circle shadow">
                          <i className="fas fa-dollar-sign" />
                        </div>
                      </div>
                    </div>
                    <Link to="/finanzas" className="text-sm text-primary mt-2 d-block">
                      Ver finanzas →
                    </Link>
                  </div>
                </div>
              </div>

              <div className="col-xl-3 col-lg-6">
                <div className="card card-stats mb-4 mb-xl-0 shadow">
                  <div className="card-body">
                    <div className="row">
                      <div className="col">
                        <h5 className="card-title text-uppercase text-muted mb-0">
                          Docentes Activos
                        </h5>
                        <span className="h2 font-weight-bold mb-0">
                          {kpis ? formatNumber(kpis.docentes_activos) : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-purple text-white rounded-circle shadow">
                          <i className="fas fa-chalkboard-teacher" />
                        </div>
                      </div>
                    </div>
                    <Link to="/academico" className="text-sm text-primary mt-2 d-block">
                      Ver reporte académico →
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid mt--7">
        <div className="row">
          <div className="col-lg-6 mb-4">
            <div className="card shadow">
              <div className="card-header border-0 d-flex justify-content-between align-items-center">
                <h3 className="mb-0">Rendimiento por carrera (top 5)</h3>
                <Link to="/academico" className="btn btn-sm btn-primary">
                  Ver todo
                </Link>
              </div>
              <div className="card-body">
                {rendimientoCarrera.length > 0 ? (
                  <div style={{ height: 220 }}>
                    <Bar
                      data={rendimientoChartData}
                      options={{
                        plugins: { legend: { display: false } },
                        responsive: true,
                        maintainAspectRatio: false,
                      }}
                    />
                  </div>
                ) : (
                  <p className="text-muted mb-0">
                    {loading ? "Cargando..." : "Sin datos de rendimiento."}
                  </p>
                )}
              </div>
            </div>
          </div>

          <div className="col-lg-6 mb-4">
            <div className="card shadow">
              <div className="card-header border-0 d-flex justify-content-between align-items-center">
                <h3 className="mb-0">Resumen por área</h3>
              </div>
              <div className="card-body">
                <ul className="list-unstyled mb-0">
                  <li className="mb-3">
                    <Link to="/academico" className="text-dark font-weight-bold">
                      Reporte Académico
                    </Link>
                    <p className="text-muted small mb-0 mt-1">
                      Aprovechamiento por carrera, materias críticas y ranking de
                      docentes.
                    </p>
                  </li>
                  <li className="mb-3">
                    <Link to="/control-escolar" className="text-dark font-weight-bold">
                      Control Escolar
                    </Link>
                    <p className="text-muted small mb-0 mt-1">
                      {estatusInscripcion.length
                        ? `${estatusInscripcion
                            .map((e) => `${e.estatus}: ${e.total}`)
                            .join(" · ")}`
                        : "Lista de alumnos, estatus de inscripción y gestión de grupos."}
                    </p>
                  </li>
                  <li>
                    <Link to="/finanzas" className="text-dark font-weight-bold">
                      Finanzas
                    </Link>
                    <p className="text-muted small mb-0 mt-1">
                      Control de pagos, ingresos mensuales
                      {morososCount > 0 &&
                        ` · ${morososCount} alumno(s) con posible adeudo`}
                      .
                    </p>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <footer className="footer">
          <div className="row align-items-center justify-content-xl-between">
            <div className="col-xl-6">
              <div className="copyright text-center text-xl-left text-muted">
                © {new Date().getFullYear()}{" "}
                <span className="font-weight-bold ml-1">Panel Escolar Argon</span>
              </div>
            </div>
            <div className="col-xl-6">
              <ul className="nav nav-footer justify-content-center justify-content-xl-end">
                <li className="nav-item">
                  <span className="nav-link">Escuela 360</span>
                </li>
              </ul>
            </div>
          </div>
        </footer>
      </div>
    </>
  );
}

export default Home;
