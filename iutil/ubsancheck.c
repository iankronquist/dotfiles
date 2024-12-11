#include <stdio.h>
#include <stdlib.h>

enum UbsanCheck {
#define UBSAN_CHECK(name, _type, _info) name,
#include "../../llvm-project/compiler-rt/lib/ubsan/ubsan_checks.inc"
#undef UBSAN_CHECK
};
struct UbsanCheckInfo {
	enum UbsanCheck name;
	const char *type;
	const char *info;
} UBSAN_CHECK_INFO[] = {

#define UBSAN_CHECK(_name, _type, _info) [_name] = { .name = _name, .type = _type, .info = _info },

#include "../../llvm-project/compiler-rt/lib/ubsan/ubsan_checks.inc"
#undef UBSAN_CHECK
};

int main(int argc, char *argv[]) {
	if (argc < 2) {
		printf("%s UBSAN_CHECK_ID\n", argc >= 1 ? argv[0]  : "ubsancheck");
		return -1;
	}
	int check = strtol(argv[1], NULL, 0);
	if (check < 0) {
		printf("No negative args %d\n", check);
		return -1;
	}
	printf("check %d\n", check);
	check = check & 0xff;

	if (check > sizeof(UBSAN_CHECK_INFO)/sizeof(UBSAN_CHECK_INFO[0])) {
		printf("OOB arg, maybe recompile this tool %d\n", check);
		return -1;
	}

	__builtin_dump_struct(&UBSAN_CHECK_INFO[check], &printf);


	return 0;
}
