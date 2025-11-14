package vista;

import controlador.ControladorRecetas;
import modelo.Categoria;
import javax.swing.*;
import java.awt.*;

/**
 * Dialogo para crear/editar categorias
 */
public class DialogoCategoria extends JDialog {

    private ControladorRecetas controlador;
    private Categoria categoriaEditar;

    private JTextField txtNombre;
    private JTextArea txtDescripcion;
    private JButton btnGuardar;
    private JButton btnCancelar;

    public DialogoCategoria(Frame owner, ControladorRecetas controlador, Categoria categoria) {
        super(owner, true);
        this.controlador = controlador;
        this.categoriaEditar = categoria;
        initComponents();
    }

    private void initComponents() {
        setTitle(categoriaEditar == null ? "Nueva Categoría" : "Editar Categoría");
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

        // Descripci�n
        gbc.gridx = 0; gbc.gridy = 1;
        mainPanel.add(new JLabel("Descripción:"), gbc);
        txtDescripcion = new JTextArea(4, 20);
        txtDescripcion.setLineWrap(true);
        JScrollPane scrollDesc = new JScrollPane(txtDescripcion);
        gbc.gridx = 1;
        gbc.weighty = 1;
        mainPanel.add(scrollDesc, gbc);

        // Botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnGuardar = new JButton("Guardar");
        btnGuardar.addActionListener(e -> guardar());
        btnCancelar = new JButton("Cancelar");
        btnCancelar.addActionListener(e -> dispose());
        panelBotones.add(btnGuardar);
        panelBotones.add(btnCancelar);

        gbc.gridx = 0; gbc.gridy = 2;
        gbc.gridwidth = 2;
        mainPanel.add(panelBotones, gbc);

        if (categoriaEditar != null) {
            txtNombre.setText(categoriaEditar.getNombre());
            txtDescripcion.setText(categoriaEditar.getDescripcion());
        }

        add(new JScrollPane(mainPanel));
    }

    private void guardar() {
        String nombre = txtNombre.getText();
        String descripcion = txtDescripcion.getText();

        if (categoriaEditar == null) {
            if (controlador.crearCategoria(nombre, descripcion)) {
                dispose();
            }
        } else {
            if (controlador.actualizarCategoria(categoriaEditar.getIdCategoria(), nombre, descripcion)) {
                dispose();
            }
        }
    }
}