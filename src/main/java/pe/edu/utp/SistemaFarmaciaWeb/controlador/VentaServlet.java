package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pe.edu.utp.SistemaFarmaciaWeb.dao.ClienteDAO;
import pe.edu.utp.SistemaFarmaciaWeb.dao.MedicamentoDAO;
import pe.edu.utp.SistemaFarmaciaWeb.dao.VentaDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.DetalleVenta;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Venta;


@WebServlet(name = "VentaServlet", urlPatterns = {"/VentaServlet"})
public class VentaServlet extends HttpServlet {

    private final VentaDAO ventaDAO = new VentaDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final MedicamentoDAO medicamentoDAO = new MedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("listaClientes", clienteDAO.listarActivos());
        request.setAttribute("listaMedicamentos", medicamentoDAO.listarTodos());
        
        request.getRequestDispatcher("/WEB-INF/views/pos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");

        if ("ProcesarVenta".equalsIgnoreCase(accion)) {
            try {
                HttpSession sesion = request.getSession(false);
                Usuario cajero = (Usuario) sesion.getAttribute("usuarioLogueado");

                int idCliente = Integer.parseInt(request.getParameter("idCliente"));
                String tipoComprobante = request.getParameter("tipoComprobante");
                String metodoPago = request.getParameter("metodoPago");
                String cartDataJSON = request.getParameter("cartData");

                Gson gson = new Gson();
                Type listType = new TypeToken<List<DetalleVenta>>(){}.getType();
                List<DetalleVenta> carrito = gson.fromJson(cartDataJSON, listType);

                double totalVenta = 0;
                for (DetalleVenta item : carrito) {
                    totalVenta += (item.getPrecio() * item.getCantidad());
                }
                
                double subtotal = Math.round((totalVenta / 1.18) * 100.0) / 100.0;
                double igv = Math.round((totalVenta - subtotal) * 100.0) / 100.0;

                Venta ventaObj = new Venta();
                ventaObj.setIdCliente(idCliente);
                ventaObj.setIdUsuario(cajero.getIdUsuario());
                ventaObj.setTipoComprobante(tipoComprobante);
                ventaObj.setMetodoPago(metodoPago);
                ventaObj.setTotal(totalVenta);
                ventaObj.setSubtotal(subtotal);
                ventaObj.setIgv(igv);
                ventaObj.setDetalles(carrito);

                boolean exito = ventaDAO.registrarVenta(ventaObj);

                if (exito) {
                    response.sendRedirect("VentaServlet?msg=ok");
                } else {
                    response.sendRedirect("VentaServlet?msg=error");
                }

            } catch (JsonSyntaxException | IOException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("VentaServlet?msg=error");
            }
        }
    }
}