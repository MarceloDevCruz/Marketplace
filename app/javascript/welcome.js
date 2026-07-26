// Welcome form submission with SweetAlert2
import Swal from 'sweetalert2'

document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('welcome-form');
  const submitBtn = document.getElementById('submit-btn');
  
  if (!form) return;

  form.addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Disable submit button
    submitBtn.disabled = true;
    submitBtn.textContent = 'Processando...';
    
    // Get form data
    const formData = new FormData(form);
    
    try {
      // Submit form via fetch
      const response = await fetch(form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      });
      
      const data = await response.json();
      
      if (response.ok) {
        // Show success SweetAlert
        Swal.fire({
          icon: 'success',
          title: 'Perfil atualizado!',
          text: 'Suas informações foram atualizadas com sucesso. O processamento está em andamento.',
          confirmButtonText: 'OK',
          confirmButtonColor: '#3b82f6',
          background: '#0b1f39',
          color: '#ffffff',
          customClass: {
            popup: 'rounded-2xl border border-white/10',
            confirmButton: 'rounded-lg bg-blue-600 hover:bg-blue-500 px-6 py-2'
          }
        }).then(() => {
          // Redirect to home after confirmation
          window.location.href = '/';
        });
      } else {
        throw new Error(data.message || 'Erro ao atualizar perfil');
      }
    } catch (error) {
      // Show error SweetAlert
      Swal.fire({
        icon: 'error',
        title: 'Erro!',
        text: error.message || 'Ocorreu um erro ao atualizar seu perfil. Tente novamente.',
        confirmButtonText: 'OK',
        confirmButtonColor: '#ef4444',
        background: '#0b1f39',
        color: '#ffffff',
        customClass: {
          popup: 'rounded-2xl border border-white/10',
          confirmButton: 'rounded-lg bg-red-600 hover:bg-red-500 px-6 py-2'
        }
      });
      
      // Re-enable submit button
      submitBtn.disabled = false;
      submitBtn.textContent = 'Atualizar Informações';
    }
  });
});

