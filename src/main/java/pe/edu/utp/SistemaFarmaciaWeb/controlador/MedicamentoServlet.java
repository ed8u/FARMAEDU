/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pe.edu.utp.SistemaFarmaciaWeb.dao.CatalogoDAO;
import pe.edu.utp.SistemaFarmaciaWeb.dao.MedicamentoDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Medicamento;

@WebServlet(name = "MedicamentoServlet", urlPatterns = {"/MedicamentoServlet"})
public class MedicamentoServlet extends HttpServlet {

    private final MedicamentoDAO medDao = new MedicamentoDAO();
    private final CatalogoDAO catDao = new CatalogoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null || accion.equalsIgnoreCase("listar")) {
            cargarCatalogos(request);
            List<Medicamento> lista = medDao.listarTodos();
            request.setAttribute("listaMedicamentos", lista);
            request.getRequestDispatcher("/WEB-INF/views/medicamentos.jsp").forward(request, response);

        } else if (accion.equalsIgnoreCase("eliminar")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                medDao.eliminarLogico(id);
            } catch (NumberFormatException e) {
                System.err.println("Error ID Medicamento inválido: " + e.getMessage());
            }
            response.sendRedirect("MedicamentoServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");

        Medicamento med = new Medicamento();
        med.setCodigoBarras(request.getParameter("txtCodigo"));
        med.setNombreComercial(request.getParameter("txtNombre"));
        med.setConcentracion(request.getParameter("txtConcentracion"));

        med.setIdPrincipio(Integer.parseInt(request.getParameter("cboPrincipio")));
        med.setIdForma(Integer.parseInt(request.getParameter("cboForma")));
        med.setIdPresentacion(Integer.parseInt(request.getParameter("cboPresentacion")));
        med.setIdLaboratorio(Integer.parseInt(request.getParameter("cboLaboratorio")));
        med.setIdCategoria(Integer.parseInt(request.getParameter("cboCategoria")));

        String strCompra = request.getParameter("txtPrecioCompra");
        med.setPrecioCompraRef(strCompra != null && !strCompra.isEmpty() ? new BigDecimal(strCompra) : BigDecimal.ZERO);
        med.setPrecioVenta(new BigDecimal(request.getParameter("txtPrecioVenta")));
        med.setStockMinimo(Integer.parseInt(request.getParameter("txtStockMinimo")));

        String receta = request.getParameter("chkReceta");
        med.setRecetaObligatoria(receta != null && (receta.equals("1") || receta.equalsIgnoreCase("on") || receta.equalsIgnoreCase("true")));

        if ("Guardar".equalsIgnoreCase(accion)) {
            medDao.registrar(med);
        } else if ("Actualizar".equalsIgnoreCase(accion)) {
            med.setIdMedicamento(Integer.parseInt(request.getParameter("txtId")));
            medDao.actualizar(med);
        }

        response.sendRedirect("MedicamentoServlet?accion=listar");
    }

    private void cargarCatalogos(HttpServletRequest request) {
        request.setAttribute("listaCategorias", catDao.listarCategorias());
        request.setAttribute("listaLaboratorios", catDao.listarLaboratorios());
        request.setAttribute("listaPrincipios", catDao.listarPrincipios());
        request.setAttribute("listaFormas", catDao.listarFormas());
        request.setAttribute("listaPresentaciones", catDao.listarPresentaciones());
    }
}
