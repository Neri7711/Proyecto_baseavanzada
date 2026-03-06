import React from "react";
import { Outlet, NavLink, useLocation } from "react-router-dom";

const ROUTE_TITLES = {
  "/": "Inicio",
  "/dashboard": "Dashboard Principal",
  "/academico": "Reporte Académico",
  "/control-escolar": "Control Escolar",
  "/finanzas": "Finanzas",
};

function Layout() {
  const location = useLocation();
  const pathname = location.pathname;
  const title = ROUTE_TITLES[pathname] ?? "Escuela 360";

  return (
    <>
      <nav
        className="navbar navbar-vertical navbar-expand-md fixed-left navbar-light bg-white"
        id="sidenav-main"
      >
        <div className="container-fluid">
          <NavLink to="/" className="navbar-brand pt-0 px-0 text-decoration-none">
            <h2 className="text-primary mb-0">Escuela 360</h2>
            <small className="text-muted d-block">Panel de Gestión Escolar</small>
          </NavLink>
          <div className="collapse navbar-collapse">
            <ul className="navbar-nav px-0 mt-4">
              <li className="nav-item">
                <NavLink
                  to="/"
                  className={({ isActive }) =>
                    "nav-link" + (isActive ? " active" : "")
                  }
                >
                  <i className="ni ni-hat-3 text-primary" /> Inicio
                </NavLink>
              </li>
              <li className="nav-item">
                <NavLink
                  to="/dashboard"
                  className={({ isActive }) =>
                    "nav-link" + (isActive ? " active" : "")
                  }
                >
                  <i className="ni ni-tv-2 text-primary" /> Dashboard
                </NavLink>
              </li>
              <li className="nav-item">
                <NavLink
                  to="/academico"
                  className={({ isActive }) =>
                    "nav-link" + (isActive ? " active" : "")
                  }
                >
                  <i className="ni ni-hat-3 text-info" /> Reporte Académico
                </NavLink>
              </li>
              <li className="nav-item">
                <NavLink
                  to="/control-escolar"
                  className={({ isActive }) =>
                    "nav-link" + (isActive ? " active" : "")
                  }
                >
                  <i className="ni ni-badge text-warning" /> Control Escolar
                </NavLink>
              </li>
              <li className="nav-item">
                <NavLink
                  to="/finanzas"
                  className={({ isActive }) =>
                    "nav-link" + (isActive ? " active" : "")
                  }
                >
                  <i className="ni ni-credit-card text-success" /> Finanzas
                </NavLink>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <div className="main-content" id="panel">
        <nav
          className="navbar navbar-top navbar-expand-md navbar-dark bg-gradient-primary"
          id="navbar-main"
        >
          <div className="container-fluid">
            <span className="h4 mb-0 text-white d-none d-lg-inline-block">
              {title}
            </span>
            <form className="navbar-search navbar-search-dark form-inline mr-3 d-none d-md-flex ml-lg-auto">
              <div className="form-group mb-0">
                <div className="input-group input-group-alternative">
                  <div className="input-group-prepend">
                    <span className="input-group-text">
                      <i className="fas fa-search" />
                    </span>
                  </div>
                  <input
                    className="form-control"
                    placeholder="Buscar alumno, carrera..."
                    type="text"
                  />
                </div>
              </div>
            </form>
            <ul className="navbar-nav align-items-center d-none d-md-flex">
              <li className="nav-item dropdown">
                <a
                  className="nav-link pr-0"
                  href="#perfil"
                  onClick={(e) => e.preventDefault()}
                >
                  <div className="media align-items-center">
                    <span className="avatar avatar-sm rounded-circle">
                      <i className="ni ni-circle-08 text-white" />
                    </span>
                    <div className="media-body ml-2 d-none d-lg-block">
                      <span className="mb-0 text-sm font-weight-bold text-white">
                        Coordinación Escolar
                      </span>
                    </div>
                  </div>
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <Outlet />
      </div>
    </>
  );
}

export default Layout;
