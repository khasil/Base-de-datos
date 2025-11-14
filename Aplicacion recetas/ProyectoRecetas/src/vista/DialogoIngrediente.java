package vista;

import controlador.ControladorRecetas;
import modelo.Ingrediente;
import javax.swing.*;
import java.awt.*;

/**
 * Diálogo para crear/editar ingredientes
 */
public class DialogoIngrediente extends JDialog {

    private ControladorRecetas controlador;
    private Ingrediente ingredienteEditar;

    private JTextField txtNombre;
    private JTextField txtUnidad;
    private JButton btnGuardar;
    private JButton btnCancelar;

    public DialogoIngrediente(Frame owner, ControladorRecetas controlador, Ingrediente ingrediente) {
        super(owner, true);
        this.controlador = controlador;
        this.ingredienteEditar = ingrediente;
        initComponents();
    }

    private void initComponents() {
        setTitle(ingredienteEditar == null ? "Nuevo Ingrediente" : "Editar Ingrediente");
        setSize(400, 200);
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

        // Unidad
        gbc.gridx = 0; gbc.gridy = 1;
        mainPanel.add(new JLabel("Unidad de Medida:"), gbc);
        txtUnidad = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(txtUnidad, gbc);

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

        if (ingredienteEditar != null) {
            txtNombre.setText(ingredienteEditar.getNombre());
            txtUnidad.setText(ingredienteEditar.getUnidadMedida());
        }

        add(mainPanel);
    }

    private void guardar() {
        String nombre = txtNombre.getText();
        String unidad = txtUnidad.getText();

        if (ingredienteEditar == null) {
            if (controlador.crearIngrediente(nombre, unidad)) {
                dispose();
            }
        } else {
            if (controlador.actualizarIngrediente(ingredienteEditar.getIdIngrediente(), nombre, unidad)) {
                dispose();
            }
        }
    }
}