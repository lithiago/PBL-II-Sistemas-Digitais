#include <linux/module.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>
#include <linux/io.h>
#include <linux/delay.h>

#define GPU_BASE 0xFF200000  // Endereço base da GPU na FPGA
#define WBR_REG_OFFSET 0x00  // Offset do registrador WBR
#define WSM_REG_OFFSET 0x04  // Offset do registrador WSM
#define DATA_A_OFFSET 0x10   // Offset da FIFO de instruções
#define DATA_B_OFFSET 0x14   // Offset da FIFO de dados
#define START_OFFSET 0x18    // Offset do sinal de start
#define WRFULL_OFFSET 0x1C   // Offset do sinal de FIFO cheia

static void __iomem *gpu_base;
static volatile int *wbr_reg, *wsm_reg, *data_a, *data_b, *start_signal, *wrfull_signal;
static dev_t dev_num;
static struct cdev gpu_cdev;

// Função de escrita: Envia instruções e dados para a GPU
static ssize_t gpu_write(struct file *file, const char __user *buffer, size_t len, loff_t *offset) {
    uint32_t instruction_data[2];

    if (len != sizeof(instruction_data))
        return -EINVAL;

    // Copiar dados do espaço de usuário para o kernel
    if (copy_from_user(instruction_data, buffer, len))
        return -EFAULT;

    // Verificar se a FIFO está cheia
    while (*wrfull_signal) {
        msleep(10);  // Espera enquanto a FIFO está cheia
    }

    // Escrever os dados nos registradores correspondentes
    *data_a = instruction_data[0];  // Envia o comando/instrução para o registrador de instruções
    *data_b = instruction_data[1];  // Envia os dados para o registrador de dados
    *start_signal = 1;              // Sinaliza para a GPU começar a processar os dados
    *start_signal = 0;              // Resetar o sinal de start

    return len;
}

// Função de leitura: Lê o status da GPU ou FIFO
static ssize_t gpu_read(struct file *file, char __user *buffer, size_t len, loff_t *offset) {
    uint32_t status;

    // Ler o status da FIFO (ou outro status relevante)
    status = *wrfull_signal;  // Exemplo: Lendo o estado da FIFO para ver se está cheia

    if (copy_to_user(buffer, &status, sizeof(status)))
        return -EFAULT;

    return sizeof(status);
}

// Operações de arquivo suportadas pelo driver
static const struct file_operations fops = {
    .owner = THIS_MODULE,
    .read = gpu_read,
    .write = gpu_write,
};

// Função de inicialização do módulo
static int __init gpu_init(void) {
    int result;

    // Alocar número major e minor para o driver
    result = alloc_chrdev_region(&dev_num, 0, 1, "gpu_device");
    if (result < 0) {
        printk(KERN_ERR "Falha ao alocar char device\n");
        return result;
    }

    // Inicializar e adicionar o char device
    cdev_init(&gpu_cdev, &fops);
    result = cdev_add(&gpu_cdev, dev_num, 1);
    if (result < 0) {
        unregister_chrdev_region(dev_num, 1);
        return result;
    }

    // Mapear os registradores da GPU no espaço de endereçamento do kernel
    gpu_base = ioremap(GPU_BASE, 0x1000);
    if (!gpu_base) {
        unregister_chrdev_region(dev_num, 1);
        return -ENOMEM;
    }

    // Mapear os ponteiros para os registradores da GPU
    wbr_reg = gpu_base + WBR_REG_OFFSET;
    wsm_reg = gpu_base + WSM_REG_OFFSET;
    data_a = gpu_base + DATA_A_OFFSET;
    data_b = gpu_base + DATA_B_OFFSET;
    start_signal = gpu_base + START_OFFSET;
    wrfull_signal = gpu_base + WRFULL_OFFSET;

    printk(KERN_INFO "Driver da GPU inicializado\n");
    return 0;
}

// Função de saída do módulo (descarregamento)
static void __exit gpu_exit(void) {
    iounmap(gpu_base);               // Desmapear o espaço de memória mapeado
    cdev_del(&gpu_cdev);             // Remover o dispositivo de caractere
    unregister_chrdev_region(dev_num, 1);  // Desregistrar o número major/minor
    printk(KERN_INFO "Driver da GPU removido\n");
}

module_init(gpu_init);
module_exit(gpu_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Seu Nome");
MODULE_DESCRIPTION("Driver de GPU implementado na FPGA");
