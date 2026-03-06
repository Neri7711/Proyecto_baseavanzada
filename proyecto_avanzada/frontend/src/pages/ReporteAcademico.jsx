import React, { useEffect, useState } from "react";
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

function ReporteAcademico() {
  const [rendimientoCarrera, setRendimientoCarrera] = useState([]);
  const [materiasCriticas, setMateriasCriticas] = useState([]);
  const [rankingDocentes, setRankingDocentes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchAll = async () => {
      try {
        const [r, m, d] = await Promise.all([
          axios.get(`${API_BASE}/api/vistas/vw_rendimiento_por_carrera`),
          axios.get(`${API_BASE}/api/academico/materias-criticas`),
          axios.get(`${API_BASE}/api/academico/ranking-docentes`),
        ]);
        setRendimientoCarrera(Array.isArray(r.data) ? r.data : []);
        setMateriasCriticas(Array.isArray(m.data) ? m.data : []);
        setRankingDocentes(Array.isArray(d.data) ? d.data : []);
      } catch (err) {
        console.error(err);
        setError("Error al cargar los datos académicos.");
      } finally {
        setLoading(false);
      }
    };
    fetchAll();
  }, []);

  const chartData = {
    labels: rendimientoCarrera.map((x) => x.carrera),
    datasets: [
      {
        label: "Promedio general",
        backgroundColor: "#5e72e4",
        borderColor: "#5e72e4",
        borderWidth: 1,
        data: rendimientoCarrera.map((x) => Number(x.promedio_general || 0)),
      },
    ],
  };

  return (
    <>
      <div className="header bg-gradient-info pb-8 pt-5 pt-md-8">
        <div className="container-fluid">
          <div className="header-body">
            {error && (
              <div className="alert alert-danger mb-4" role="alert">
                {error}
              </div>
            )}
            <h1 className="text-white mb-0">Reporte Académico</h1>
            <p className="text-white opacity-8">
              Aprovechamiento por carrera, materias críticas y ranking de docentes.
            </p>
          </div>
        </div>
      </div>

      <div className="container-fluid mt--7">
        <div className="row">
          <div className="col-xl-8 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Aprovechamiento por Carrera</h3>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Carrera</th>
                      <th scope="col">Promedio General</th>
                      <th scope="col">Estatus</th>
                    </tr>
                  </thead>
                  <tbody>
                    {rendimientoCarrera.map((row, index) => (
                      <tr key={index}>
                        <th scope="row">
                          <span className="mb-0 text-sm font-weight-bold">
                            {row.carrera}
                          </span>
                        </th>
                        <td>{formatNumber(row.promedio_general, 2)}</td>
                        <td>
                          <span className="badge badge-dot mr-4">
                            <i
                              className={
                                Number(row.promedio_general) >= 80
                                  ? "bg-success"
                                  : "bg-warning"
                              }
                            />
                            <span className="status">
                              {Number(row.promedio_general) >= 80
                                ? "Excelente"
                                : "Crítico"}
                            </span>
                          </span>
                        </td>
                      </tr>
                    ))}
                    {!loading && rendimientoCarrera.length === 0 && (
                      <tr>
                        <td colSpan={3} className="text-center text-muted">
                          Sin información de rendimiento disponible.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div className="col-xl-4 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Gráfica de Rendimiento</h3>
                <span className="text-muted small">
                  Comparativo por carrera.
                </span>
              </div>
              <div className="card-body">
                {rendimientoCarrera.length > 0 ? (
                  <div style={{ height: 320 }}>
                    <Bar
                      data={chartData}
                      options={{
                        plugins: { legend: { display: false } },
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: "y",
                      }}
                    />
                  </div>
                ) : (
                  <p className="text-muted mb-0">
                    No hay datos para mostrar la gráfica.
                  </p>
                )}
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-xl-6 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Materias Críticas</h3>
                <span className="text-muted small">
                  Promedio &lt; 70.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Materia</th>
                      <th scope="col">Clave</th>
                      <th scope="col">Promedio</th>
                    </tr>
                  </thead>
                  <tbody>
                    {materiasCriticas.map((row, index) => (
                      <tr key={index}>
                        <td>{row.materia}</td>
                        <td>{row.clave}</td>
                        <td>{formatNumber(row.promedio, 2)}</td>
                      </tr>
                    ))}
                    {!loading && materiasCriticas.length === 0 && (
                      <tr>
                        <td colSpan={3} className="text-center text-muted">
                          No se encontraron materias críticas.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div className="col-xl-6 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Ranking de Docentes</h3>
                <span className="text-muted small">
                  Promedio de alumnos por docente.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Docente</th>
                      <th scope="col">Núm. empleado</th>
                      <th scope="col">Promedio alumnos</th>
                    </tr>
                  </thead>
                  <tbody>
                    {rankingDocentes.map((row, index) => (
                      <tr key={index}>
                        <td>
                          {row.nombre} {row.apellidos}
                        </td>
                        <td>{row.num_empleado}</td>
                        <td>{formatNumber(row.promedio_alumnos, 2)}</td>
                      </tr>
                    ))}
                    {!loading && rankingDocentes.length === 0 && (
                      <tr>
                        <td colSpan={3} className="text-center text-muted">
                          Sin información de ranking.
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

export default ReporteAcademico;
