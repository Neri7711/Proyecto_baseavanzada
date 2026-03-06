import React, { useEffect, useState } from "react";
import axios from "axios";
import { Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend,
} from "chart.js";
import { API_BASE, formatNumber } from "../utils/api";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend
);

function Finanzas() {
  const [estadoCuenta, setEstadoCuenta] = useState([]);
  const [morosos, setMorosos] = useState([]);
  const [ingresosMensuales, setIngresosMensuales] = useState([]);
  const [resumenPagos, setResumenPagos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchAll = async () => {
      try {
        const [ec, mo, ing, res] = await Promise.all([
          axios.get(`${API_BASE}/api/finanzas/estado-cuenta`),
          axios.get(`${API_BASE}/api/finanzas/morosidad`),
          axios.get(`${API_BASE}/api/finanzas/ingresos-mensuales`),
          axios.get(`${API_BASE}/api/finanzas/resumen-pagos`),
        ]);
        setEstadoCuenta(Array.isArray(ec.data) ? ec.data : []);
        setMorosos(Array.isArray(mo.data) ? mo.data : []);
        setIngresosMensuales(Array.isArray(ing.data) ? ing.data : []);
        setResumenPagos(Array.isArray(res.data) ? res.data : []);
      } catch (err) {
        console.error(err);
        setError("Error al cargar datos financieros.");
      } finally {
        setLoading(false);
      }
    };
    fetchAll();
  }, []);

  const lineData = {
    labels: ingresosMensuales.map((x) => x.mes),
    datasets: [
      {
        label: "Ingresos mensuales",
        data: ingresosMensuales.map((x) => Number(x.total_ingresos || 0)),
        borderColor: "#11cdef",
        backgroundColor: "rgba(17, 205, 239, 0.1)",
        tension: 0.3,
      },
    ],
  };

  return (
    <>
      <div className="header bg-gradient-success pb-8 pt-5 pt-md-8">
        <div className="container-fluid">
          <div className="header-body">
            {error && (
              <div className="alert alert-danger mb-4" role="alert">
                {error}
              </div>
            )}
            <h1 className="text-white mb-0">Finanzas</h1>
            <p className="text-white opacity-8">
              Control de pagos, estado de cuenta, ingresos y morosidad.
            </p>
          </div>
        </div>
      </div>

      <div className="container-fluid mt--7">
        <div className="row">
          <div className="col-xl-8 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Control de Pagos</h3>
                <span className="text-muted small">
                  Estado de cuenta por alumno y periodo.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Alumno</th>
                      <th scope="col">Periodo</th>
                      <th scope="col">Pagos realizados</th>
                      <th scope="col">Total pagado</th>
                    </tr>
                  </thead>
                  <tbody>
                    {estadoCuenta.slice(0, 15).map((row, index) => (
                      <tr key={index}>
                        <td>{row.alumno}</td>
                        <td>{row.periodo}</td>
                        <td>{row.pagos_realizados}</td>
                        <td>${formatNumber(row.total_pagado, 2)}</td>
                      </tr>
                    ))}
                    {!loading && estadoCuenta.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center text-muted">
                          No hay información de pagos.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            <div className="card shadow mt-4">
              <div className="card-header border-0">
                <h3 className="mb-0">Resumen de Pagos por Concepto</h3>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Periodo</th>
                      <th scope="col">Concepto</th>
                      <th scope="col">Cantidad</th>
                      <th scope="col">Total recaudado</th>
                    </tr>
                  </thead>
                  <tbody>
                    {resumenPagos.slice(0, 15).map((row, index) => (
                      <tr key={index}>
                        <td>{row.periodo}</td>
                        <td>{row.concepto}</td>
                        <td>{row.cantidad_pagos}</td>
                        <td>${formatNumber(row.total_recaudado, 2)}</td>
                      </tr>
                    ))}
                    {!loading && resumenPagos.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center text-muted">
                          No hay resumen de pagos.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div className="col-xl-4 mb-4">
            <div className="card shadow mb-4">
              <div className="card-header border-0">
                <h3 className="mb-0">Ingresos Mensuales</h3>
                <span className="text-muted small">
                  Evolución por mes.
                </span>
              </div>
              <div className="card-body">
                {ingresosMensuales.length > 0 ? (
                  <div style={{ height: 260 }}>
                    <Line
                      data={lineData}
                      options={{
                        plugins: { legend: { display: false } },
                        maintainAspectRatio: false,
                        responsive: true,
                        scales: {
                          y: {
                            ticks: {
                              callback: (v) => `$${formatNumber(v, 0)}`,
                            },
                          },
                        },
                      }}
                    />
                  </div>
                ) : (
                  <p className="text-muted mb-0">
                    No hay datos de ingresos.
                  </p>
                )}
              </div>
            </div>

            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Alumnos con Adeudos</h3>
                <span className="text-muted small">
                  Posible morosidad.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Nombre</th>
                      <th scope="col">Correo</th>
                      <th scope="col">Estatus</th>
                    </tr>
                  </thead>
                  <tbody>
                    {morosos.slice(0, 10).map((row, index) => (
                      <tr key={index}>
                        <td>
                          {row.nombre} {row.apellidos}
                        </td>
                        <td>{row.correo}</td>
                        <td>
                          <span className="badge badge-warning">
                            {row.estatus}
                          </span>
                        </td>
                      </tr>
                    ))}
                    {!loading && morosos.length === 0 && (
                      <tr>
                        <td colSpan={3} className="text-center text-muted">
                          No se detectaron alumnos con morosidad.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
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
          </div>
        </footer>
      </div>
    </>
  );
}

export default Finanzas;
