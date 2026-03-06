import React, { useEffect, useState } from "react";
import axios from "axios";
import { Pie } from "react-chartjs-2";
import {
  Chart as ChartJS,
  ArcElement,
  Tooltip,
  Legend,
} from "chart.js";
import { API_BASE, formatNumber } from "../utils/api";

ChartJS.register(ArcElement, Tooltip, Legend);

function ControlEscolar() {
  const [alumnos, setAlumnos] = useState([]);
  const [estatusInscripcion, setEstatusInscripcion] = useState([]);
  const [saturacionCursos, setSaturacionCursos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchAll = async () => {
      try {
        const [a, e, s] = await Promise.all([
          axios.get(`${API_BASE}/api/control-escolar/alumnos`),
          axios.get(`${API_BASE}/api/control-escolar/estatus-inscripcion`),
          axios.get(`${API_BASE}/api/control-escolar/saturacion-cursos`),
        ]);
        setAlumnos(Array.isArray(a.data) ? a.data : []);
        setEstatusInscripcion(Array.isArray(e.data) ? e.data : []);
        setSaturacionCursos(Array.isArray(s.data) ? s.data : []);
      } catch (err) {
        console.error(err);
        setError("Error al cargar datos de control escolar.");
      } finally {
        setLoading(false);
      }
    };
    fetchAll();
  }, []);

  const pieData = {
    labels: estatusInscripcion.map((x) =>
      x.estatus === "Activo" ? "Regulares" : x.estatus
    ),
    datasets: [
      {
        data: estatusInscripcion.map((x) => Number(x.total || 0)),
        backgroundColor: ["#2dce89", "#f5365c"],
      },
    ],
  };

  return (
    <>
      <div className="header bg-gradient-warning pb-8 pt-5 pt-md-8">
        <div className="container-fluid">
          <div className="header-body">
            {error && (
              <div className="alert alert-danger mb-4" role="alert">
                {error}
              </div>
            )}
            <h1 className="text-white mb-0">Control Escolar</h1>
            <p className="text-white opacity-8">
              Lista de alumnos, estatus de inscripción y gestión de grupos.
            </p>
          </div>
        </div>
      </div>

      <div className="container-fluid mt--7">
        <div className="row">
          <div className="col-xl-8 mb-4">
            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Lista de Alumnos</h3>
                <span className="text-muted small">
                  Por carrera y facultad.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Alumno</th>
                      <th scope="col">Carrera</th>
                      <th scope="col">Facultad</th>
                      <th scope="col">Estatus</th>
                    </tr>
                  </thead>
                  <tbody>
                    {alumnos.slice(0, 20).map((row) => (
                      <tr key={row.id_alumno}>
                        <td>{row.alumno}</td>
                        <td>{row.carrera}</td>
                        <td>{row.facultad}</td>
                        <td>
                          <span
                            className={
                              row.estatus_alumno === "Activo"
                                ? "badge badge-success"
                                : "badge badge-secondary"
                            }
                          >
                            {row.estatus_alumno}
                          </span>
                        </td>
                      </tr>
                    ))}
                    {!loading && alumnos.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center text-muted">
                          No hay alumnos registrados.
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
                <h3 className="mb-0">Estatus de Inscripción</h3>
                <span className="text-muted small">
                  Activos vs baja.
                </span>
              </div>
              <div className="card-body">
                {estatusInscripcion.length > 0 ? (
                  <div style={{ height: 220 }}>
                    <Pie
                      data={pieData}
                      options={{
                        plugins: { legend: { position: "bottom" } },
                        maintainAspectRatio: false,
                        responsive: true,
                      }}
                    />
                  </div>
                ) : (
                  <p className="text-muted mb-0">
                    No hay datos para la gráfica.
                  </p>
                )}
              </div>
            </div>

            <div className="card shadow">
              <div className="card-header border-0">
                <h3 className="mb-0">Gestión de Grupos</h3>
                <span className="text-muted small">
                  Saturación de cursos.
                </span>
              </div>
              <div className="table-responsive">
                <table className="table align-items-center table-flush">
                  <thead className="thead-light">
                    <tr>
                      <th scope="col">Materia</th>
                      <th scope="col">Cupo</th>
                      <th scope="col">Inscritos</th>
                      <th scope="col">% Lleno</th>
                    </tr>
                  </thead>
                  <tbody>
                    {saturacionCursos.slice(0, 10).map((row, index) => (
                      <tr key={index}>
                        <td>{row.materia}</td>
                        <td>{row.cupo_max}</td>
                        <td>{row.inscritos}</td>
                        <td>
                          <span
                            className={
                              Number(row.porcentaje_llenado) >= 90
                                ? "text-danger"
                                : "text-muted"
                            }
                          >
                            {formatNumber(row.porcentaje_llenado, 2)}%
                          </span>
                        </td>
                      </tr>
                    ))}
                    {!loading && saturacionCursos.length === 0 && (
                      <tr>
                        <td colSpan={4} className="text-center text-muted">
                          Sin información de saturación.
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

export default ControlEscolar;
