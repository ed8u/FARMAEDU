/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.UsuarioDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.Usuario;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("Ingresar".equalsIgnoreCase(accion)) {
            String user = request.getParameter("txtUser");
            String pass = request.getParameter("txtPass");

            // Llamamos a la base de datos
            Usuario usr = dao.validar(user, pass);

            if (usr != null) {
                // Si el usuario existe, creamos una Sesión HTTP
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogueado", usr);

                // Redirección según el Rol (1 = Admin, 2 = Vendedor)
                if (usr.getIdRol() == 1) {
                    response.sendRedirect("dashboard_admin.jsp");
                } else {
                    response.sendRedirect("dashboard_vendedor.jsp");
                }
            } else {
                // Si falla, enviamos un mensaje de error a la vista
                request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }
    }
}