package vista;

import controlador.ControladorRecetas;
import modelo.Usuario;
import javax.swing.*;
import java.awt.*;

/**
 * Dialogo para crear/editar usuarios
 */
public class DialogoUsuario extends JDialog {

    private ControladorRecetas controlador;
    private Usuario usuarioEditar;

    private JTextField txtNombre;
    private JTextField txtCorreo;
    private JPasswordField txtContrasena;
    private JComboBox<String> comboRol;
    private JButton btnGuardar;
    private JButton btnCancelar;

    public DialogoUsuario(Frame owner, ControladorRecetas controlador, Usuario usuario) {
        super(owner, true);
        this.controlador = controlador;
        this.usuarioEditar = usuario;

        initComponents();
    }

    private void initComponents() {
        setTitle(usuarioEditar == null ? "Nuevo Usuario" : "Editar Usuario");
        setSize(400, 300);
        setLocationRelativeTo(getOwner());
        setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // Nombre
        gbc.gridx = 0; gbc.gridy = 0;
        mainPanel.add(new JLabel("Nombre:"), gbc);
        txtNombre = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(txtNombre, gbc);

        // Correo
        gbc.gridx = 0; gbc.gridy = 1;
        mainPanel.add(new JLabel("Correo:"), gbc);
        txtCorreo = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(txtCorreo, gbc);

        // Contraseña
        gbc.gridx = 0; gbc.gridy = 2;
        mainPanel.add(new JLabel("Contraseña:"), gbc);
        txtContrasena = new JPasswordField(20);
        gbc.gridx = 1;
        mainPanel.add(txtContrasena, gbc);

        // Rol
        gbc.gridx = 0; gbc.gridy = 3;
        mainPanel.add(new JLabel("Rol:"), gbc);
        comboRol = new JComboBox<>(new String[]{"Usuario", "Cocinero", "Administrador"});
        gbc.gridx = 1;
        mainPanel.add(comboRol, gbc);

        // Botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnGuardar = new JButton("Guardar");
        btnGuardar.addActionListener(e -> guardar());
        btnCancelar = new JButton("Cancelar");
        btnCancelar.addActionListener(e -> dispose());
        panelBotones.add(btnGuardar);
        panelBotones.add(btnCancelar);

        gbc.gridx = 0; gbc.gridy = 4;
        gbc.gridwidth = 2;
        mainPanel.add(panelBotones, gbc);

        // Cargar datos si es edicion
        if (usuarioEditar != null) {
            txtNombre.setText(usuarioEditar.getNombre());
            txtCorreo.setText(usuarioEditar.getCorreo());
            comboRol.setSelectedItem(usuarioEditar.getRol());
            txtContrasena.setEnabled(false);
        }

        add(mainPanel);
    }

    private void guardar() {
        String nombre = txtNombre.getText();
        String correo = txtCorreo.getText();
        String contrasena = new String(txtContrasena.getPassword());
        String rol = (String) comboRol.getSelectedItem();

        if (usuarioEditar == null) {
            if (controlador.crearUsuario(nombre, correo, contrasena, rol)) {
                dispose();
            }
        } else {
            if (controlador.actualizarUsuario(usuarioEditar.getIdUsuario(), nombre, correo, rol)) {
                dispose();
            }
        }
    }
}