package controlador;

import dao.DashboardDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    private DashboardDAO dao = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener datos reales de la BD
        double ingresosHoy = dao.getIngresosHoy();
        int ventasHoy = dao.getCantidadVentasHoy();
        int totalClientes = dao.getTotalClientes();
        int alertas = dao.getAlertasSanitarias();
        
        // 2. Enviar los datos al JSP (usando atributos)
        request.setAttribute("kpiIngresos", ingresosHoy);
        request.setAttribute("kpiVentas", ventasHoy);
        request.setAttribute("kpiClientes", totalClientes);
        request.setAttribute("kpiAlertas", alertas);
        
        // 3. Redirigir a la vista del Dashboard
        request.getRequestDispatcher("dashboard_admin.jsp").forward(request, response);
    }
}