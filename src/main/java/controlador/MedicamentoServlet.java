package controlador;

import dao.MedicamentoDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Medicamento;

@WebServlet(name = "MedicamentoServlet", urlPatterns = {"/MedicamentoServlet"})
public class MedicamentoServlet extends HttpServlet {

    private MedicamentoDAO dao = new MedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if (accion == null || accion.equalsIgnoreCase("listar")) {
            List<Medicamento> lista = dao.listarTodos();
            request.setAttribute("listaMedicamentos", lista);
            // Redirige a la vista principal que rediseñaremos con Modals
            request.getRequestDispatcher("medicamentos.jsp").forward(request, response);
            
        } else if (accion.equalsIgnoreCase("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
            response.sendRedirect("MedicamentoServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");
        
        Medicamento med = new Medicamento();
        
        // Captura de los nuevos campos de la base de datos ERP
        med.setCodigoBarras(request.getParameter("txtCodigo"));
        med.setNombreComercial(request.getParameter("txtNombre"));
        med.setIdPrincipio(Integer.parseInt(request.getParameter("cboPrincipio")));
        med.setIdForma(Integer.parseInt(request.getParameter("cboForma")));
        med.setConcentracion(request.getParameter("txtConcentracion"));
        med.setIdPresentacion(Integer.parseInt(request.getParameter("cboPresentacion")));
        med.setIdLaboratorio(Integer.parseInt(request.getParameter("cboLaboratorio")));
        med.setIdCategoria(Integer.parseInt(request.getParameter("cboCategoria")));
        
        // Validación para el checkbox de receta obligatoria
        String receta = request.getParameter("chkReceta");
        med.setRecetaObligatoria(receta != null && receta.equals("1"));
        
        med.setPrecioCompraRef(Double.parseDouble(request.getParameter("txtPrecioCompra")));
        med.setPrecioVenta(Double.parseDouble(request.getParameter("txtPrecioVenta")));
        med.setStockMinimo(Integer.parseInt(request.getParameter("txtStockMinimo")));

        if (accion != null && accion.equalsIgnoreCase("Guardar")) {
            dao.registrar(med);
        } else if (accion != null && accion.equalsIgnoreCase("Actualizar")) {
            med.setIdMedicamento(Integer.parseInt(request.getParameter("txtId")));
            // Aquí irá dao.actualizar(med); cuando lo agreguemos al DAO
        }
        
        response.sendRedirect("MedicamentoServlet?accion=listar");
    }
}