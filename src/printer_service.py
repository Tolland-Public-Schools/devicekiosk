import subprocess


class PrinterError(Exception):
    pass


class PrinterService:
	"""Helper service that sends text payloads to the local printer via lpr."""

	def __init__(self, lpr_path: str = "/usr/bin/lpr") -> None:
		self.lpr_path = lpr_path

	def print_job(self, text: str, encoding: str = "utf-8") -> None:
		if text is None:
			raise ValueError("text cannot be None")

		try:
			process = subprocess.Popen(self.lpr_path, stdin=subprocess.PIPE)
		except OSError as exc:
			raise PrinterError(f"Unable to start printer command: {exc}") from exc

		process.communicate(text.encode(encoding))

		if process.returncode != 0:
			raise PrinterError(f"Printing failed with return code {process.returncode}")
