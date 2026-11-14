<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Punto de Venta (POS) - FARMAEDU</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .pos-search-bar { background: #fff; padding: 15px; border-radius: 12px; border: 1px solid var(--border-color); margin-bottom: 15px; }
        .pos-search-bar input { border: 2px solid #e2e8f0; border-radius: 8px; padding: 12px 20px; width: 100%; font-size: 1rem; outline: none; transition: border 0.3s; }
        .pos-search-bar input:focus { border-color: var(--primary-color); }
        
        .cart-panel { background: #fff; border-radius: 12px; border: 1px solid var(--border-color); height: calc(100vh - 240px); overflow-y: auto; }
        .cart-table th { background: #f8fafc; position: sticky; top: 0; font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); }
        .cart-table td { vertical-align: middle; padding: 15px 10px; font-weight: 600; font-size: 0.9rem;}
        
        .qty-control { display: flex; align-items: center; gap: 10px; }
        .qty-control button { background: #f1f5f9; border: 1px solid #cbd5e1; width: 30px; height: 30px; border-radius: 6px; font-weight: bold; color: #334155; display: flex; align-items: center; justify-content: center; padding: 0;}
        .qty-control button:hover { background: #e2e8f0; }
        .qty-control span { min-width: 25px; text-align: center; }

        .checkout-panel { background: #fff; border-radius: 12px; border: 1px solid var(--border-color); padding: 20px; height: calc(100vh - 145px); display: flex; flex-direction: column;}
        
        .totals-box { background: #f8fafc; padding: 20px; border-radius: 8px; margin-top: auto; border: 1px solid #e2e8f0; }
        .total-row { display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 8px; color: #475569; font-weight: 600;}
        .total-final { display: flex; justify-content: space-between; font-size: 1.8rem; font-weight: 800; color: #0f172a; margin-top: 10px; border-top: 2px dashed #cbd5e1; padding-top: 15px;}
        
        .btn-pay { background: var(--primary-color); color: white; width: 100%; padding: 15px; border-radius: 8px; font-size: 1.2rem; font-weight: 800; border: none; margin-top: 15px; transition: background 0.3s; }
        .btn-pay:hover { background: #047857; }

        .payment-methods { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }
        .pay-method { border: 2px solid #e2e8f0; padding: 10px; border-radius: 8px; text-align: center; cursor: pointer; color: var(--text-muted); font-weight: 700; font-size: 0.85rem; transition: all 0.2s;}
        .pay-method:hover { border-color: #cbd5e1; background: #f8fafc; }
        .pay-method.active { border-color: var(--primary-color); color: var(--primary-color); background: #ecfdf5; }
        .pay-method i { font-size: 1.5rem; display: block; margin-bottom: 5px; }

        .search-results { position: absolute; left: 15px; right: 15px; top: 72px; background: white; max-height: 260px; overflow-y: auto; border: 1px solid #cbd5e1; border-radius: 8px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); z-index: 1000; display: none; }
        .search-item { padding: 12px 15px; border-bottom: 1px solid #f1f5f9; cursor: pointer; display: flex; justify-content: space-between; align-items: center;}
        .search-item:hover { background: #ecfdf5; }
    </style>
</head>
<body>

    <div class="wrapper">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="topbar.jsp" />

            <div class="content-area" style="padding: 15px 20px;">

                <c:if test="${param.msg == 'ok'}">
                    <div class="alert alert-success alert-dismissible fade show py-2 fw-bold" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i> ¡Venta registrada con éxito! El stock ha sido descontado bajo criterio FEFO.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'error'}">
                    <div class="alert alert-danger alert-dismissible fade show py-2 fw-bold" role="alert">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> No se pudo procesar la venta. Verifique el stock disponible de los lotes.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row g-3">
                    
                    <!-- LADO IZQUIERDO: BUSCADOR Y CARRITO -->
                    <div class="col-lg-8">
                        <div class="pos-search-bar position-relative">
                            <input type="text" id="inputBuscar" placeholder="🔍 Escriba el nombre del medicamento o escanee código de barras..." autocomplete="off" onkeyup="filtrarProductos()">
                            
                            <div class="search-results" id="listaResultados">
                                <c:forEach var="m" items="${listaMedicamentos}">
                                    <c:if test="${m.stockTotal > 0}">
                                        <div class="search-item item-producto" 
                                             data-busqueda="${m.nombreComercial.toLowerCase()} ${m.codigoBarras.toLowerCase()} ${m.nombrePrincipio.toLowerCase()}"
                                             onclick="agregarAlCarrito(${m.idMedicamento}, '${m.nombreComercial} (${m.concentracion})', ${m.precioVenta}, ${m.stockTotal})">
                                            <div>
                                                <strong class="text-dark">${m.nombreComercial} - ${m.concentracion}</strong>
                                                <c:if test="${m.recetaObligatoria}">
                                                    <span class="badge bg-danger ms-1" style="font-size: 0.6rem;">Rx Receta</span>
                                                </c:if>
                                                <br>
                                                <small class="text-muted">Cód: ${m.codigoBarras} | Lab: ${m.nombreLaboratorio} | <strong>Stock: ${m.stockTotal} unid.</strong></small>
                                            </div>
                                            <span class="badge bg-success" style="font-size: 0.95rem;">S/ ${String.format("%.2f", m.precioVenta)}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="cart-panel">
                            <table class="table table-hover cart-table mb-0">
                                <thead>
                                    <tr>
                                        <th style="width: 50%;">Producto / Medicamento</th>
                                        <th style="width: 15%; text-align: center;">Cant.</th>
                                        <th style="width: 15%; text-align: right;">P. Unit.</th>
                                        <th style="width: 15%; text-align: right;">Subtotal</th>
                                        <th style="width: 5%;"></th>
                                    </tr>
                                </thead>
                                <tbody id="tablaCarrito">
                                    <tr id="filaVacia">
                                        <td colspan="5" class="text-center text-muted py-5">
                                            <i class="fa-solid fa-basket-shopping mb-3" style="font-size: 2.5rem; color: #cbd5e1;"></i><br>
                                            El carrito está vacío. Haga clic en el buscador superior para agregar medicamentos con stock.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- LADO DERECHO: PANEL DE COBRO Y CLIENTE -->
                    <div class="col-lg-4">
                        <form action="VentaServlet" method="POST" id="formVenta" class="checkout-panel">
                            <input type="hidden" name="accionForm" value="ProcesarVenta">
                            <input type="hidden" name="cartData" id="cartData">

                            <div class="mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Comprobante:</label>
                                <select name="tipoComprobante" class="form-select fw-bold border-2">
                                    <option value="BOLETA">Boleta Electrónica</option>
                                    <option value="FACTURA">Factura Electrónica</option>
                                    <option value="TICKET">Ticket de Control</option>
                                </select>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Cliente / Paciente:</label>
                                <select name="idCliente" class="form-select border-2" required>
                                    <c:forEach var="c" items="${listaClientes}">
                                        <option value="${c.idCliente}">${c.nombresRsocial} (${c.dniRuc})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Método de Pago:</label>
                            <input type="hidden" name="metodoPago" id="inputMetodoPago" value="EFECTIVO">
                            <div class="payment-methods">
                                <div class="pay-method active" onclick="seleccionarPago(this, 'EFECTIVO')">
                                    <i class="fa-solid fa-money-bill-wave"></i> Efectivo
                                </div>
                                <div class="pay-method" onclick="seleccionarPago(this, 'VISA')">
                                    <i class="fa-brands fa-cc-visa"></i> Tarjeta / POS
                                </div>
                                <div class="pay-method" onclick="seleccionarPago(this, 'YAPE')">
                                    <i class="fa-solid fa-mobile-screen"></i> Yape / Plin
                                </div>
                                <div class="pay-method" onclick="seleccionarPago(this, 'TRANSFERENCIA')">
                                    <i class="fa-solid fa-building-columns"></i> Transf.
                                </div>
                            </div>

                            <div class="totals-box">
                                <div class="total-row">
                                    <span>Op. Gravada (Sin IGV)</span>
                                    <span id="txtSubtotal">S/ 0.00</span>
                                </div>
                                <div class="total-row">
                                    <span>IGV (18%)</span>
                                    <span id="txtIgv">S/ 0.00</span>
                                </div>
                                <div class="total-final">
                                    <span>TOTAL</span>
                                    <span id="txtTotal">S/ 0.00</span>
                                </div>
                            </div>

                            <button type="button" class="btn-pay" onclick="procesarVenta()">
                                <i class="fa-solid fa-receipt me-2"></i> Emitir y Cobrar
                            </button>
                        </form>
                    </div>

                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let carrito = [];

        const inputBuscar = document.getElementById('inputBuscar');
        const listaResultados = document.getElementById('listaResultados');

        inputBuscar.addEventListener('focus', function() {
            listaResultados.style.display = 'block';
            filtrarProductos();
        });

        document.addEventListener('click', function(event) {
            if (!event.target.closest('.pos-search-bar')) {
                listaResultados.style.display = 'none';
            }
        });

        function filtrarProductos() {
            const texto = inputBuscar.value.toLowerCase().trim();
            const items = document.querySelectorAll('.item-producto');
            listaResultados.style.display = 'block';

            items.forEach(item => {
                const data = item.getAttribute('data-busqueda');
                item.style.display = data.includes(texto) ? 'flex' : 'none';
            });
        }

        function seleccionarPago(element, metodo) {
            document.querySelectorAll('.pay-method').forEach(el => el.classList.remove('active'));
            element.classList.add('active');
            document.getElementById('inputMetodoPago').value = metodo;
        }

        function agregarAlCarrito(id, nombre, precio, stockMax) {
            listaResultados.style.display = 'none';
            inputBuscar.value = '';

            let index = carrito.findIndex(item => item.id === id);
            if (index !== -1) {
                if (carrito[index].cantidad < stockMax) {
                    carrito[index].cantidad++;
                } else {
                    alert("Stock máximo alcanzado para este producto (" + stockMax + " unid).");
                }
            } else {
                carrito.push({ id: id, nombre: nombre, precio: precio, cantidad: 1, stockMax: stockMax });
            }
            renderizarCarrito();
        }

        function cambiarCantidad(index, delta) {
            let item = carrito[index];
            if (delta === 1 && item.cantidad < item.stockMax) {
                item.cantidad++;
            } else if (delta === 1 && item.cantidad >= item.stockMax) {
                alert("No hay más unidades disponibles en inventario.");
            } else if (delta === -1 && item.cantidad > 1) {
                item.cantidad--;
            }
            renderizarCarrito();
        }

        function eliminarDelCarrito(index) {
            carrito.splice(index, 1);
            renderizarCarrito();
        }

        function renderizarCarrito() {
            const tbody = document.getElementById('tablaCarrito');
            tbody.innerHTML = '';
            
            if (carrito.length === 0) {
                tbody.innerHTML = `
                    <tr id="filaVacia">
                        <td colspan="5" class="text-center text-muted py-5">
                            <i class="fa-solid fa-basket-shopping mb-3" style="font-size: 2.5rem; color: #cbd5e1;"></i><br>
                            El carrito está vacío. Haga clic en el buscador superior para agregar medicamentos con stock.
                        </td>
                    </tr>
                `;
                actualizarTotales(0);
                return;
            }

            let sumaBruta = 0;

            carrito.forEach((item, index) => {
                let subtotalItem = item.precio * item.cantidad;
                sumaBruta += subtotalItem;

                let tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>\${item.nombre}</td>
                    <td>
                        <div class="qty-control justify-content-center">
                            <button type="button" onclick="cambiarCantidad(\${index}, -1)">-</button>
                            <span>\${item.cantidad}</span>
                            <button type="button" onclick="cambiarCantidad(\${index}, 1)">+</button>
                        </div>
                    </td>
                    <td class="text-end">S/ \${item.precio.toFixed(2)}</td>
                    <td class="text-end text-success fw-bold">S/ \${subtotalItem.toFixed(2)}</td>
                    <td class="text-center">
                        <i class="fa-solid fa-xmark text-danger" style="cursor:pointer;" onclick="eliminarDelCarrito(\${index})"></i>
                    </td>
                `;
                tbody.appendChild(tr);
            });

            actualizarTotales(sumaBruta);
        }

        function actualizarTotales(sumaBruta) {
            let total = sumaBruta;
            let subtotal = total / 1.18;
            let igv = total - subtotal;

            document.getElementById('txtSubtotal').innerText = 'S/ ' + subtotal.toFixed(2);
            document.getElementById('txtIgv').innerText = 'S/ ' + igv.toFixed(2);
            document.getElementById('txtTotal').innerText = 'S/ ' + total.toFixed(2);
        }

        function procesarVenta() {
            if (carrito.length === 0) {
                alert("Agregue al menos un medicamento al carrito antes de cobrar.");
                return;
            }
            document.getElementById('cartData').value = JSON.stringify(carrito);
            document.getElementById('formVenta').submit();
        }
    </script>
</body>
</html>