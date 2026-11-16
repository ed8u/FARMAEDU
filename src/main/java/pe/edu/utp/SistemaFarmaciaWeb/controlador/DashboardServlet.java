package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pe.edu.utp.SistemaFarmaciaWeb.dao.DashboardDAO;
import pe.edu.utp.SistemaFarmaciaWeb.dao.VentaDAO;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dao = new DashboardDAO();
    private final VentaDAO ventaDAO = new VentaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("kpiClientes", dao.getTotalClientes());
        request.setAttribute("kpiMedicamentos", dao.getTotalMedicamentos());
        request.setAttribute("kpiLotesPorVencer", dao.getLotesPorVencer());
        request.setAttribute("kpiBajoStock", dao.getMedicamentosBajoStock());
        request.setAttribute("listaLotesCriticos", dao.getLotesCriticosFEFO());

        request.setAttribute("kpiIngresosHoy", ventaDAO.obtenerIngresosHoy());
        request.setAttribute("kpiVentasHoy", ventaDAO.contarVentasHoy());
        request.setAttribute("listaUltimasVentas", ventaDAO.listarUltimasVentas(6));

        String[] chartData = ventaDAO.obtenerDatosGrafico7Dias();
        request.setAttribute("chartLabels", chartData[0]);
        request.setAttribute("chartValores", chartData[1]);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}