FROM python:2.7
RUN mkdir /src
COPY  dcm2bids_wholeSession.py /src
COPY xnatjsession /src/xnatjsession
COPY xnatbidsfns /src/xnatbidsfns

RUN apt-get update && apt-get install -y \
        curl \
        mercurial \
        pigz \
        zip \
        && \
    pip install \
        dicom \
        nipype \
        requests \
        && \
    rm -r ${HOME}/.cache/pip && \
    curl -L https://github.com/rordenlab/dcm2niix/releases/download/v1.0.20241211/dcm2niix_lnx.zip  > dcm2niix.zip && \
    unzip dcm2niix.zip && \
    mv dcm2niix /usr/local/bin && \
    chmod a+x /usr/local/bin/dcm2niix && \
    rm dcm* && \
    apt-get remove -y \
        curl \
        mercurial \
        zip \
        && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /src

LABEL org.nrg.commands="[{\"name\": \"dcm2bids-session-v12\", \"description\": \"Runs dcm2niix https://github.com/rordenlab/dcm2niix/releases/download/v1.0.20241211/dcm2niix_lnx.zip on a session's scans, and uploads the NIFTI and BIDS json\", \"version\": \"2.10\", \"schema-version\": \"1.0\", \"image\": \"xnatworks/dcm2bids-session:2.10\", \"type\": \"docker\", \"command-line\": \"python dcm2bids_wholeSession.py #SESSION_ID# #SESSION_LABEL# #SUBJECT# #PROJECT# #OVERWRITE# #SKIP# #FIELD# --host \$XNAT_HOST --user \$XNAT_USER --pass \$XNAT_PASS --upload-by-ref False --dicomdir /dicom --niftidir /nifti\", \"override-entrypoint\": true, \"mounts\": [{\"name\": \"nifti\", \"writable\": true, \"path\": \"/nifti\"}, {\"name\": \"input\", \"writable\": false, \"path\": \"#SESSION_DIR#\"}], \"environment-variables\": {}, \"ports\": {}, \"inputs\": [{\"name\": \"session_id\", \"description\": \"XNAT ID of the session\", \"type\": \"string\", \"required\": true, \"replacement-key\": \"#SESSION_ID#\", \"command-line-flag\": \"--session\", \"select-values\": []}, {\"name\": \"overwrite\", \"description\": \"Overwrite any existing NIFTI and BIDS scan resources?\", \"type\": \"boolean\", \"default-value\": \"false\", \"required\": false, \"replacement-key\": \"#OVERWRITE#\", \"command-line-flag\": \"--overwrite\", \"true-value\": \"True\", \"false-value\": \"False\", \"select-values\": []}, {\"name\": \"session_label\", \"description\": \"Session\", \"type\": \"string\", \"required\": true, \"replacement-key\": \"#SESSION_LABEL#\", \"command-line-flag\": \"--sessionLabel\", \"select-values\": []}, {\"name\": \"project\", \"description\": \"Project\", \"type\": \"string\", \"required\": true, \"replacement-key\": \"#PROJECT#\", \"command-line-flag\": \"--project\", \"select-values\": []}, {\"name\": \"subject_label\", \"description\": \"Subject\", \"type\": \"string\", \"required\": true, \"replacement-key\": \"#SUBJECT#\", \"command-line-flag\": \"--subject\", \"select-values\": []}, {\"name\": \"skipUnusable\", \"label\": \"Skip unusable\", \"description\": \"Skip BIDS conversion of unusable scans?\", \"type\": \"boolean\", \"default-value\": \"false\", \"required\": false, \"replacement-key\": \"#SKIP#\", \"command-line-flag\": \"--skipUnusable\", \"true-value\": \"True\", \"false-value\": \"False\", \"select-values\": []}, {\"name\": \"field\", \"label\": \"Scan-level field for mapping\", \"description\": \"If your site/project bidsmap config uses e.g., \\"xnat_field\\": \\"T1\\", then \\"T1\\" should be the value of your selection here.\", \"type\": \"select-one\", \"default-value\": \"series_description\", \"required\": true, \"replacement-key\": \"#FIELD#\", \"command-line-flag\": \"--field\", \"select-values\": [\"series_description\", \"type\", \"series_class\"]}], \"outputs\": [], \"xnat\": [{\"name\": \"dcm2bids-session\", \"description\": \"Run dcm2bids on a Session(v12)\", \"contexts\": [\"xnat:imageSessionData\"], \"external-inputs\": [{\"name\": \"session\", \"description\": \"Input session\", \"type\": \"Session\", \"required\": true, \"provides-files-for-command-mount\": \"input\", \"load-children\": true}], \"derived-inputs\": [{\"name\": \"session-id\", \"description\": \"The session's id\", \"type\": \"string\", \"required\": true, \"provides-value-for-command-input\": \"session_id\", \"load-children\": true, \"derived-from-wrapper-input\": \"session\", \"derived-from-xnat-object-property\": \"id\", \"multiple\": false}, {\"name\": \"session-label\", \"description\": \"The session's label\", \"type\": \"string\", \"required\": true, \"provides-value-for-command-input\": \"session_label\", \"load-children\": true, \"derived-from-wrapper-input\": \"session\", \"derived-from-xnat-object-property\": \"label\", \"multiple\": false}, {\"name\": \"subject-label\", \"description\": \"The subject label\", \"type\": \"Subject\", \"required\": true, \"provides-value-for-command-input\": \"subject_label\", \"load-children\": true, \"derived-from-wrapper-input\": \"session\", \"derived-from-xnat-object-property\": \"label\", \"multiple\": false}, {\"name\": \"project-id\", \"description\": \"The project\", \"type\": \"Project\", \"required\": true, \"provides-value-for-command-input\": \"project\", \"load-children\": true, \"derived-from-wrapper-input\": \"session\", \"derived-from-xnat-object-property\": \"id\", \"multiple\": false}, {\"name\": \"session-dir\", \"description\": \"The session's archive dir\", \"type\": \"string\", \"required\": true, \"replacement-key\": \"#SESSION_DIR#\", \"user-settable\": false, \"load-children\": true, \"derived-from-wrapper-input\": \"session\", \"derived-from-xnat-object-property\": \"directory\", \"multiple\": false}], \"output-handlers\": []}], \"container-labels\": {}, \"generic-resources\": {}, \"ulimits\": {}, \"secrets\": []}]"