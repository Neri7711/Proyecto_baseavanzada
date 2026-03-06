import React, { useEffect, useState } from "react";
import axios from "axios";
import { API_BASE, formatNumber } from "../utils/api";

function Dashboard() {
  const [kpis, setKpis] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    axios
      .get(`${API_BASE}/api/dashboard/kpis`)
      .then((res) => {
        if (res.data?.error) setError(res.data.error);
        else setKpis(res.data);
      })
      .catch((err) => {
        console.error(err);
        setError("Error al cargar los indicadores.");
      })
      .finally(() => setLoading(false));
  }, []);

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
                            : loading ? "..." : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-info text-white rounded-circle shadow">
                          <i className="fas fa-chart-bar" />
                        </div>
                      </div>
                    </div>
                    <p className="mt-3 mb-0 text-muted text-sm">
                      Promedio general de todas las carreras.
                    </p>
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
                          {kpis ? formatNumber(kpis.total_alumnos) : loading ? "..." : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-orange text-white rounded-circle shadow">
                          <i className="fas fa-users" />
                        </div>
                      </div>
                    </div>
                    <p className="mt-3 mb-0 text-muted text-sm">
                      Total de estudiantes registrados.
                    </p>
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
                            : loading ? "..." : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-green text-white rounded-circle shadow">
                          <i className="fas fa-dollar-sign" />
                        </div>
                      </div>
                    </div>
                    <p className="mt-3 mb-0 text-muted text-sm">
                      Porcentaje de alumnos al corriente en sus pagos.
                    </p>
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
                          {kpis ? formatNumber(kpis.docentes_activos) : loading ? "..." : "--"}
                        </span>
                      </div>
                      <div className="col-auto">
                        <div className="icon icon-shape bg-purple text-white rounded-circle shadow">
                          <i className="fas fa-chalkboard-teacher" />
                        </div>
                      </div>
                    </div>
                    <p className="mt-3 mb-0 text-muted text-sm">
                      Profesores impartiendo clases este ciclo.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="container-fluid mt--7">
        <div className="row">
          <div className="col-12">
            <div className="card shadow">
              <div className="card-body">
                <h5 className="card-title">Vista general del dashboard</h5>
                <p className="text-muted mb-0">
                  Los indicadores anteriores resumen el estado actual del sistema.
                  Usa el menú lateral para acceder a Reporte Académico, Control
                  Escolar y Finanzas con todo el detalle.
                </p>
              </div>
            </div>
          </div>
        </div>

        <footer className="footer mt-4">
          <div className="row align-items-center justify-content-xl-between">
            <div className="col-xl-6">
              <div className="copyright text-center text-xl-left text-muted">
                © {new Date().getFullYear()}{" "}
                <span className="font-weight-bold ml-1">Panel Escolar Argon</span>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </>
  );
}

export default Dashboard;
