#include "../../cL4/cL4-future/kernel/src/plat/common/lib/bundle/bundle.h"

#include <assert.h>
#include <stdio.h>
#include <stdint.h>

typedef uint64_t u64_t;
typedef uint32_t u32_t;
typedef uint16_t u16_t;
typedef uint8_t u8_t;

/* bundle args size */
#define BUNDLE_ARGS_SIZE 432
/* bundle args magic */
#define BUNDLE_ARGS_MAGIC 0x42554e44
/* bundle args type */
#define BUNDLE_ARGS_TYPE_CTRR 0
/* bundle args version */
#define BUNDLE_ARGS_VERSION 3
/* bundle flags */
#define BUNDLE_FLAG_ASLR (1ULL << 0)

#if defined(__ASSEMBLER__)
/* bundle image header */
.macro BUNDLE_IMAGE_HEADER
    /* trampoline */
    b      _start
    /* padding */
    .word 0
    /* magic */
    .word BUNDLE_ARGS_MAGIC
    /* type */
    .short BUNDLE_ARGS_TYPE_CTRR
    /* version */
    .short BUNDLE_ARGS_VERSION
    /* remainder of bundle args */
    .space (BUNDLE_ARGS_SIZE - 16)
.endm

#else /* !defined(__ASSEMBLER__) */

#include <l4/l4.h>
#include <l4/region.h>

/* bundle args */
typedef struct {
    /* trampoline jump instruction */
    u32_t trampoline;
    /* alignment padding */
    u32_t padding;
    /* bundle magic */
    u32_t magic;
    /* bundle type */
    u16_t type;
    /* bundle version */
    u16_t version;
    /* kernel uuid */
    u8_t kernel_uuid[16];
    /* kernel entropy */
    u64_t kernel_entropy[2];
    /* user entropy */
    u64_t user_entropy[2];
    /* bundle flags */
    u64_t flags;
    /* physical memory 0 base */
    u64_t global_phys_mem_0_base;
    /* physical memory 0 size */
    u64_t global_phys_mem_0_size;
    /* physical memory 1 base */
    u64_t global_phys_mem_1_base;
    /* physical memory 1 size */
    u64_t global_phys_mem_1_size;
    /* patchbay offset (bundle relative) */
    u64_t global_patchbay_offset;
    /* memory rx region offset (global_phys_mem_0_base relative) */
    u64_t rx0_offset;
    /* memory rx region size */
    u64_t rx0_size;
    /* cpu rx kernel region offset (rx_offset relative) */
    u64_t rx0_kern_offset;
    /* cpu rx kernel region size */
    u64_t rx0_kern_size;
    /* kernel __TEXT segment offset (rx_kern_offset relative) */
    u64_t rx0_kern_kernel_text_offset;
    /* kernel __TEXT segment size */
    u64_t rx0_kern_kernel_text_size;
    /* cpu rx user region offset (rx_offset relative) */
    u64_t rx0_user_offset;
    /* cpu rx user region size */
    u64_t rx0_user_size;
    /* roottask __TEXT segment offset (rx_user_offset relative) */
    u64_t rx0_user_roottask_text_offset;
    /* roottask __TEXT segment size */
    u64_t rx0_user_roottask_text_size;
    /* roottask __TEXT segment virtual base */
    u64_t rx0_user_roottask_text_base;
    /* roottask __TEXT segment entrypoint */
    u64_t rx0_user_roottask_text_entry;
    /* application text region offset */
    u64_t rx0_user_application_text_offset;
    /* application text region size */
    u64_t rx0_user_application_text_size;
    /* memory rw region 0 offset (global_phys_mem_0_base relative) */
    u64_t rw0_offset;
    /* memory rx region 0 size */
    u64_t rw0_size;
    /* kernel __DATA segment offset (rw0_offset relative) */
    u64_t rw0_kernel_data_offset;
    /* kernel __DATA segment size */
    u64_t rw0_kernel_data_size;
    /* kernel boot memory offset (rw0_offset relative) */
    u64_t rw0_kernel_boot_memory_offset;
    /* kernel boot memory size */
    u64_t rw0_kernel_boot_memory_size;
    /* roottask __DATA segment offset (rw0_offset relative) */
    u64_t rw0_roottask_data_offset;
    /* roottask __DATA segment size */
    u64_t rw0_roottask_data_size;
    /* roottask __DATA segment size in bytes */
    u64_t rw0_roottask_data_bytes;
    /* roottask __DATA segment virtual base */
    u64_t rw0_roottask_data_base;
    /* roottask __LINKEDIT segment offset (rw0_offset relative) */
    u64_t rw0_roottask_linkedit_offset;
    /* roottask __LINKEDIT segment size */
    u64_t rw0_roottask_linkedit_size;
    /* roottask __LINKEDIT segment virtual base */
    u64_t rw0_roottask_linkedit_base;
    /* application region 0 text region offset (rw0_offset relative) */
    u64_t rw0_application_text_offset;
    /* application region 0 text region size */
    u64_t rw0_application_text_size;
    /* application region 0 data region offset (rw0_offset relative) */
    u64_t rw0_application_data_offset;
    /* application region 0 data region size */
    u64_t rw0_application_data_size;
    /* memory rw region 1 offset (global_phys_mem_1_base relative) */
    u64_t rw1_offset;
    /* memory rx region 1 size */
    u64_t rw1_size;
    /* application region 1 text region offset (rw1_offset relative) */
    u64_t rw1_application_text_offset;
    /* application region 1 text region size */
    u64_t rw1_application_text_size;
    /* application region 1 data region offset (rw1_offset relative) */
    u64_t rw1_application_data_offset;
    /* application region 1 data region size */
    u64_t rw1_application_data_size;
    /* global DER table offset (rw1_offset relative) */
    u64_t rw1_gdert_offset;
    /* global DER table page aligned size */
    u64_t rw1_gdert_size;
    /* global DER table size in bytes */
    u64_t rw1_gdert_bytes;
} __packed bundle_args_t;



int main(int argc, const char *argv[]) {
    FILE *input = fopen(argv[1], "rb");
    bundle_args_t bundle;
    assert(input != NULL);
    fread(&bundle, sizeof(bundle), 1, input);
    __builtin_dump_struct(&bundle, &printf);
}
