VENV = /home/chen/Documents/GitHub/rknn_model_zoo/.venv
PYTHON = $(VENV)/bin/python
all:
	cd ./examples/yolov8/model && \
	bash ./download_model.sh && \
	cd ../python && \
	$(PYTHON) convert.py ../model/yolov8n.onnx rk3588 i8 ../model/yolov8_rk3588.rknn && \
	$(PYTHON) convert.py ../model/yolov8n.onnx rk3568 i8 ../model/yolov8_rk3568.rknn && \
	$(PYTHON) convert.py ../model/yolov8n.onnx rk3568 i8 ../model/yolov8_rk3566.rknn

clean:
	find ./ -type f -name "*.onnx" -exec rm {} \;
	find ./ -type f -name "*.rknn" -exec rm {} \;

deb:
	debuild --no-lintian --lintian-hook "lintian --fail-on error --suppress-tags bad-distribution-in-changes-file -- %p_%v_*.changes" --no-sign -b -aarm64 -Pcross