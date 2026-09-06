<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo Médico - FARMAEDU </title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    
    <style>
        :root {
            --bg-sidebar: #022c22; 
            --bg-sidebar-hover: #064e3b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --bg-body: #f8fafc;
            --primary-color: #059669; 
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            overflow: hidden; 
            color: #1e293b;
            height: 100vh;
            margin: 0;
        }

        .wrapper { display: flex; width: 100%; height: 100vh; }

        /* SIDEBAR COMPLETO */
        .sidebar {
            width: 260px; background-color: var(--bg-sidebar); color: #a7f3d0;
            display: flex; flex-direction: column; flex-shrink: 0;
        }
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; background-color: #012119; }
        .logo-box {
            width: 32px; height: 32px; border: 1px solid #10b981; color: #10b981;
            display: flex; align-items: center; justify-content: center; border-radius: 6px; font-weight: bold;
        }
        .sidebar-header h5 { margin: 0; color: #ffffff; font-weight: 800; font-size: 1.1rem; letter-spacing: 0.5px; }
        .sidebar-header small { display: block; font-size: 0.6rem; color: #6ee7b7; letter-spacing: 1px; text-transform: uppercase;}
        .sidebar-content { flex-grow: 1; overflow-y: auto; padding-top: 10px; }
        .sidebar-content::-webkit-scrollbar { display: none; }
        .sidebar-section {
            font-size: 0.65rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.5px; color: #059669; padding: 15px 20px 5px 20px; margin: 0;
        }
        .sidebar-menu { list-style: none; padding: 0 12px; margin: 0; }
        .sidebar-menu .nav-link {
            color: #d1fae5; display: flex; align-items: center; padding: 9px 15px;
            border-radius: 8px; font-size: 0.8rem; font-weight: 500; text-decoration: none;
            transition: all 0.2s; margin-bottom: 2px;
        }
        .sidebar-menu .nav-link i.icon-main { width: 25px; font-size: 0.95rem; }
        .sidebar-menu .nav-link:hover { background-color: var(--bg-sidebar-hover); color: #ffffff; }
        .sidebar-menu .nav-link.active { background-color: #047857; color: #ffffff; font-weight: 600;}
        
        .sidebar-footer {
            padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.05);
            display: flex; align-items: center; gap: 10px; background-color: #012119;
        }
        .sidebar-footer i { font-size: 1.5rem; color: #34d399; }
        .sidebar-footer div { line-height: 1.2; }
        .sidebar-footer span { font-size: 0.8rem; font-weight: 700; color: white; display: block;}
        .sidebar-footer small { font-size: 0.65rem; color: #6ee7b7; }
        .logout-btn { margin-left: auto; color: #94a3b8; cursor: pointer; }

        /* CONTENIDO PRINCIPAL */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; height: 100vh; }

        .topbar {
            background-color: #ffffff; height: 55px; display: flex; justify-content: space-between;
            align-items: center; padding: 0 25px; border-bottom: 1px solid var(--border-color); flex-shrink: 0; font-size: 0.8rem;
        }
        .search-bar { display: flex; align-items: center; gap: 10px; width: 300px; color: var(--text-muted); }
        .search-bar input { border: none; outline: none; width: 100%; font-size: 0.85rem; }
        
        .topbar-info { display: flex; align-items: center; gap: 20px; font-weight: 500; color: #475569;}
        .topbar-icons .avatar {
            width: 28px; height: 28px; background: #0f172a; color: white; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-left: 15px; font-weight: bold;
        }

        .content-area {
            padding: 24px 30px; overflow-y: auto; height: calc(100vh - 55px); background-color: #f1f5f9;
        }

        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .page-title span { font-size: 0.65rem; font-weight: 700; color: var(--primary-color); letter-spacing: 1px; text-transform: uppercase;}
        .page-title h2 { font-weight: 800; font-size: 1.6rem; margin: 4px 0; color: #0f172a; letter-spacing: -0.5px;}
        .page-title p { color: var(--text-muted); font-size: 0.85rem; margin: 0; }
        
        .header-actions { display: flex; gap: 10px; }
        .btn-action {
            background: white; border: 1px solid var(--border-color); padding: 8px 15px;
            border-radius: 6px; font-size: 0.8rem; font-weight: 600; color: #334155; display: flex; align-items: center; gap: 8px;
        }
        .btn-primary-custom { background: var(--primary-color); border: none; color: white; }

        /* KPIs */
        .kpi-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; height: 100%;}
        .kpi-header { display: flex; justify-content: space-between; font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase;}
        .kpi-header i { font-size: 1rem; color: #94a3b8; }
        .kpi-value { font-size: 1.8rem; font-weight: 800; color: #0f172a; margin: 10px 0 5px 0;}
        .kpi-sub { font-size: 0.75rem; color: var(--text-muted); line-height: 1.3;}

        /* TABLA */
        .table-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); margin-top: 24px;}
        
        .table-custom { width: 100%; font-size: 0.85rem;}
        .table-custom th { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;}
        .table-custom td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle;}
        
        .badge-receta { background: #fee2e2; color: #991b1b; font-size: 0.65rem; font-weight: 700; padding: 3px 6px; border-radius: 4px; border: 1px solid #f87171;}
        .badge-libre { background: #dcfce7; color: #166534; font-size: 0.65rem; font-weight: 700; padding: 3px 6px; border-radius: 4px; border: 1px solid #4ade80;}

        .action-btns i { cursor: pointer; color: #64748b; font-size: 1rem; margin-right: 10px; transition: color 0.2s;}
        .action-btns i:hover { color: var(--primary-color); }
        .action-btns .btn-del:hover { color: #ef4444; }

        .dataTables_wrapper .dataTables_filter input { border: 1px solid #e2e8f0; border-radius: 6px; padding: 4px 10px; margin-left: 10px; outline: none;}
        .dt-buttons .btn { margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
                <div>
                    <h5>FARMAEDU</h5>
                    <small>HEALTHCARE ERP SUITE</small>
                </div>
            </div>

            <div class="sidebar-content">
                <p class="sidebar-section">Principal</p>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="DashboardServlet" class="nav-link"><i class="fa-solid fa-border-all icon-main"></i> Dashboard General</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-desktop icon-main"></i> Punto de Venta (POS)</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-cash-register icon-main"></i> Caja y Turnos</a></li>
                </ul>

                <p class="sidebar-section">Gestión Farmacéutica</p>
                <ul class="sidebar-menu">
                    <!-- ENLACE CORREGIDO AQUÍ -->
                    <li class="nav-item"><a href="InventarioServlet?accion=listar" class="nav-link"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario & Lotes (FEFO)</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-truck-ramp-box icon-main"></i> Compras y Proveedores</a></li>
                    <li class="nav-item"><a href="MedicamentoServlet?accion=listar" class="nav-link active"><i class="fa-solid fa-book-medical icon-main"></i> Catálogo Maestro</a></li>
                    <li class="nav-item"><a href="ClienteServlet?accion=listar" class="nav-link"><i class="fa-solid fa-users icon-main"></i> Clientes y Pacientes</a></li>
                </ul>

                <p class="sidebar-section">Reportes & Configuración</p>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-chart-line icon-main"></i> Ventas y Finanzas</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-user-shield icon-main"></i> Usuarios y Permisos</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-sliders icon-main"></i> Ajustes del Sistema</a></li>
                </ul>
            </div>
            
            <div class="sidebar-footer">
                <i class="fa-solid fa-user-doctor"></i>
                <div>
                    <span>Admin Farmacia</span>
                    <small>Sede Central</small>
                </div>
                <i class="fa-solid fa-arrow-right-from-bracket logout-btn" onclick="window.location.href='index.jsp'"></i>
            </div>
        </nav>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="main-content">
            
            <header class="topbar">
                <div class="search-bar">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Búsqueda rápida en todo el ERP...">
                </div>
                <div class="topbar-info">
                    <span><i class="fa-solid fa-store me-1 text-success"></i> Sucursal Principal</span>
                    <span><i class="fa-regular fa-clock me-1 text-success"></i> Turno Mañana (Caja 01)</span>
                </div>
                <div class="topbar-icons">
                    <i class="fa-regular fa-bell"></i>
                    <div class="avatar">A</div>
                </div>
            </header>

            <div class="content-area">
                
                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-pills"></i> FarmaEdu V1.0 • </span>
                        <h2>Catálogo Maestro de Medicamentos</h2>
                        <p>Gestión de SKUs, precios, recetas y control de stock mínimo.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoMedicamento">
                            <i class="fa-solid fa-box-open"></i> + Nuevo Medicamento
                        </button>
                    </div>
                </div>

                <!-- Lógica JSTL para contar dinámicamente Medicamentos con/sin receta -->
                <c:set var="countReceta" value="0" />
                <c:set var="countLibre" value="0" />
                <c:forEach var="m" items="${listaMedicamentos}">
                    <c:if test="${m.recetaObligatoria}">
                        <c:set var="countReceta" value="${countReceta + 1}" />
                    </c:if>
                    <c:if test="${!m.recetaObligatoria}">
                        <c:set var="countLibre" value="${countLibre + 1}" />
                    </c:if>
                </c:forEach>

                <!-- KPIs -->
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Total SKUs <i class="fa-solid fa-boxes-stacked text-primary"></i></div>
                            <div class="kpi-value text-success">${listaMedicamentos.size() > 0 ? listaMedicamentos.size() : '0'}</div>
                            <div class="kpi-sub">Productos en el catálogo.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header text-danger">Con Receta Médica (Rx) <i class="fa-solid fa-file-prescription text-danger"></i></div>
                            <div class="kpi-value text-dark">${countReceta}</div>
                            <div class="kpi-sub">Venta controlada.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header text-success">Venta Libre (OTC) <i class="fa-solid fa-basket-shopping text-success"></i></div>
                            <div class="kpi-value text-dark">${countLibre}</div>
                            <div class="kpi-sub">Sin restricción comercial.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Integridad de Precios <i class="fa-solid fa-tags text-warning"></i></div>
                            <div class="kpi-value text-dark">100%</div>
                            <div class="kpi-sub">Márgenes validados.</div>
                        </div>
                    </div>
                </div>

                <!-- TABLA DATA TABLES -->
                <div class="table-card">
                    <table id="tablaMedicamentos" class="table-custom">
                        <thead>
                            <tr>
                                <th>Código Barras</th>
                                <th>Medicamento / Concentración</th>
                                <th>Laboratorio / Categoría</th>
                                <th>Condición</th>
                                <th>Precio Venta</th>
                                <th>Stock Min.</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${listaMedicamentos}">
                                <tr>
                                    <td><strong>${m.codigoBarras}</strong></td>
                                    <td>
                                        <div style="line-height: 1.2;">
                                            <strong>${m.nombreComercial}</strong><br>
                                            <small class="text-muted">${m.nombrePrincipio} | ${m.concentracion}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="line-height: 1.2;">
                                            <strong>${m.nombreLaboratorio}</strong><br>
                                            <small class="text-muted">${m.nombreCategoria}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${m.recetaObligatoria}">
                                            <span class="badge-receta"><i class="fa-solid fa-file-signature"></i> Rx Obligatoria</span>
                                        </c:if>
                                        <c:if test="${!m.recetaObligatoria}">
                                            <span class="badge-libre"><i class="fa-solid fa-basket-shopping"></i> Libre (OTC)</span>
                                        </c:if>
                                    </td>
                                    <td><strong>S/ ${String.format("%.2f", m.precioVenta)}</strong></td>
                                    <td><span class="text-danger fw-bold">${m.stockMinimo} unid.</span></td>
                                    <td class="action-btns">
                                        <!-- En un sistema real los IDs de cbo se pasan, aquí mandamos todos los datos -->
                                        <i class="fa-solid fa-pen" title="Editar" 
                                           onclick="abrirModalEditar('${m.idMedicamento}', '${m.codigoBarras}', '${m.nombreComercial}', '${m.idPrincipio}', '${m.idForma}', '${m.concentracion}', '${m.idPresentacion}', '${m.idLaboratorio}', '${m.idCategoria}', '${m.recetaObligatoria}', '${m.precioCompraRef}', '${m.precioVenta}', '${m.stockMinimo}')"></i>
                                        
                                        <a href="MedicamentoServlet?accion=eliminar&id=${m.idMedicamento}" class="btn-del" onclick="return confirm('¿Seguro de eliminar este medicamento?');">
                                            <i class="fa-solid fa-trash-can" title="Eliminar"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <!-- ========================================================== -->
    <!-- MODALS (Diseño en 2 columnas para el formulario extenso) -->
    <!-- ========================================================== -->

    <!-- Modal Nuevo Medicamento -->
    <div class="modal fade" id="modalNuevoMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-box-open me-2"></i>Registrar Nuevo Medicamento</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Guardar">
                        
                        <!-- Uso de GRID para 2 columnas -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Código de Barras:</label>
                                <input type="text" name="txtCodigo" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Comercial:</label>
                                <input type="text" name="txtNombre" class="form-control" required autocomplete="off">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Principio Activo (DCI):</label>
                                <select name="cboPrincipio" class="form-select" required>
                                    <option value="1">Paracetamol</option>
                                    <option value="2">Amoxicilina</option>
                                    <option value="3">Ibuprofeno</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Forma Farmacéutica:</label>
                                <select name="cboForma" class="form-select" required>
                                    <option value="1">Tabletas</option>
                                    <option value="2">Jarabe</option>
                                    <option value="3">Inyectable</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Concentración (Ej: 500mg):</label>
                                <input type="text" name="txtConcentracion" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Presentación:</label>
                                <select name="cboPresentacion" class="form-select" required>
                                    <option value="1">Caja x 100</option>
                                    <option value="2">Frasco 120ml</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Laboratorio:</label>
                                <select name="cboLaboratorio" class="form-select" required>
                                    <option value="1">Bayer</option>
                                    <option value="2">Genfar</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Categoría:</label>
                                <select name="cboCategoria" class="form-select" required>
                                    <option value="1">Analgésicos</option>
                                    <option value="2">Antibióticos</option>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-1">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Precio Compra (Ref):</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-success" style="font-size: 0.8rem;">Precio Venta:</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-danger" style="font-size: 0.8rem;">Stock Mínimo:</label>
                                <input type="number" name="txtStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="chkRecetaNuevo">
                            <label class="form-check-label fw-bold text-danger" for="chkRecetaNuevo" style="font-size: 0.85rem;">
                                Requiere Receta Médica Obligatoria (Rx)
                            </label>
                        </div>

                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Guardar Medicamento</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Medicamento -->
    <div class="modal fade" id="modalEditarMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header text-white" style="background-color: #0f172a;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen me-2"></i>Editar Medicamento</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Código de Barras:</label>
                                <input type="text" name="txtCodigo" id="editCodigo" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Comercial:</label>
                                <input type="text" name="txtNombre" id="editNombre" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Principio Activo:</label>
                                <select name="cboPrincipio" id="editPrincipio" class="form-select" required>
                                    <option value="1">Paracetamol</option>
                                    <option value="2">Amoxicilina</option>
                                    <option value="3">Ibuprofeno</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Forma Farmacéutica:</label>
                                <select name="cboForma" id="editForma" class="form-select" required>
                                    <option value="1">Tabletas</option>
                                    <option value="2">Jarabe</option>
                                    <option value="3">Inyectable</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Concentración:</label>
                                <input type="text" name="txtConcentracion" id="editConcentracion" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Presentación:</label>
                                <select name="cboPresentacion" id="editPresentacion" class="form-select" required>
                                    <option value="1">Caja x 100</option>
                                    <option value="2">Frasco 120ml</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Laboratorio:</label>
                                <select name="cboLaboratorio" id="editLaboratorio" class="form-select" required>
                                    <option value="1">Bayer</option>
                                    <option value="2">Genfar</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Categoría:</label>
                                <select name="cboCategoria" id="editCategoria" class="form-select" required>
                                    <option value="1">Analgésicos</option>
                                    <option value="2">Antibióticos</option>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-1">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Precio Compra:</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" id="editPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-success" style="font-size: 0.8rem;">Precio Venta:</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" id="editPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-danger" style="font-size: 0.8rem;">Stock Mínimo:</label>
                                <input type="number" name="txtStockMinimo" id="editStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="editReceta">
                            <label class="form-check-label fw-bold text-danger" for="editReceta" style="font-size: 0.85rem;">
                                Requiere Receta Médica Obligatoria (Rx)
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-dark fw-bold">Actualizar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts Esenciales -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Scripts DataTables -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaMedicamentos').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-3"Bf>rt<"d-flex justify-content-between mt-3"ip>',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa-solid fa-file-excel me-1"></i> Exportar a Excel',
                        className: 'btn btn-success text-white fw-bold shadow-sm border-0',
                        title: 'Catálogo de Medicamentos - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fa-solid fa-file-pdf me-1"></i> Catálogo PDF',
                        className: 'btn btn-danger text-white fw-bold shadow-sm border-0 ms-2',
                        title: 'Catálogo de Medicamentos - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); },
                        orientation: 'landscape' /* El PDF se genera en horizontal por la cantidad de columnas */
                    }
                ],
                pageLength: 10
            });
        });

        // Función para cargar los datos en el Modal de Edición
        function abrirModalEditar(id, codigo, nombre, principio, forma, concentracion, presentacion, lab, cat, receta, precioC, precioV, stock) {
            document.getElementById('editId').value = id;
            document.getElementById('editCodigo').value = codigo;
            document.getElementById('editNombre').value = nombre;
            
            // Los Selects asumen valores fijos (1, 2, 3) por ahora en la vista
            document.getElementById('editPrincipio').value = principio;
            document.getElementById('editForma').value = forma;
            document.getElementById('editConcentracion').value = concentracion;
            document.getElementById('editPresentacion').value = presentacion;
            document.getElementById('editLaboratorio').value = lab;
            document.getElementById('editCategoria').value = cat;
            
            document.getElementById('editPrecioCompra').value = precioC;
            document.getElementById('editPrecioVenta').value = precioV;
            document.getElementById('editStockMinimo').value = stock;
            
            // Lógica para marcar o desmarcar el checkbox de receta
            document.getElementById('editReceta').checked = (receta === 'true');
            
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarMedicamento'));
            myModal.show();
        }
    </script>
</body>
</html>